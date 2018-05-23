Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:8435 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753147AbeEWCK7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 22:10:59 -0400
Subject: Re: [PATCH v2 0/6] btrfs_search_slot cleanups
To: Nikolay Borisov <nborisov@suse.com>, <dsterba@suse.cz>,
        Liu Bo <bo.liu@linux.alibaba.com>, <linux-btrfs@vger.kernel.org>
CC: Qu Wenruo <wqu@suse.com>
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
 <9b80bec0-b7cf-10da-f379-373fe6ec776a@cn.fujitsu.com>
 <20180522120214.GG6649@twin.jikos.cz>
 <fd6e7b1c-6cd2-c5c2-9895-1df0db5f2ccc@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <77374b4d-6878-d8cf-40b2-a5f99188c2d9@cn.fujitsu.com>
Date: Wed, 23 May 2018 10:16:55 +0800
MIME-Version: 1.0
In-Reply-To: <fd6e7b1c-6cd2-c5c2-9895-1df0db5f2ccc@suse.com>
Content-Type: multipart/mixed;
        boundary="------------C508D910112222A89A5EBBB5"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--------------C508D910112222A89A5EBBB5
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable



On 05/22/2018 08:35 PM, Nikolay Borisov wrote:
>=20
>=20
> On 22.05.2018 15:02, David Sterba wrote:
>> On Tue, May 22, 2018 at 07:05:14PM +0800, Su Yue wrote:
>>> Hi Liu and David,
>>> 	During my local xfstests on kdave/for-next, btrfs/139 failed and
>>> btrfs BUG_ON due to qgroup rescan.
>>> 	The bisect result is commit 560215eb3f32("Merge branch
>>> 'ext/liubo/search-cleanups-wip' into for-next-next-v4.18-20180521")
>>> which seems merged this patchset.
>>> 	The dmesg file is attached.
>>>
>>> On 05/18/2018 11:00 AM, Liu Bo wrote:
>>>> Here are a collection of patches I did for btrfs_search_slot().
>>>>
>>>> v2: more explicit commit log for each patch.
>>>>
>>>> Liu Bo (6):
>>>>   Btrfs: remove superfluous free_extent_buffer
>>>>   Btrfs: use more straightforward extent_buffer_uptodate
>>>>   Btrfs: move get root of btrfs_search_slot to a helper
>>>>   Btrfs: remove unused check of skip_locking
>>>>   Btrfs: grab write lock directly if write_lock_level is the max level
>>>>   Btrfs: remove always true check in unlock_up
>>>>
>>>>  fs/btrfs/ctree.c | 121 +++++++++++++++++++++++++++++++++-------------=
---------
>>>>  1 file changed, 73 insertions(+), 48 deletions(-)
>>>>
>>>
>>>
>>
>>> [   46.129166] BTRFS info (device vdb): disk space caching is enabled
>>> [   46.130545] BTRFS info (device vdb): has skinny extents
>>> [   46.171386] mount (2798) used greatest stack depth: 12920 bytes left
>>> [   46.508170] BTRFS: device fsid 83a117c7-a9ea-4bf5-b42f-7092078610d5 =
devid 1 transid 5 /dev/vdc
>>> [   46.562428] BTRFS info (device vdc): disk space caching is enabled
>>> [   46.563690] BTRFS info (device vdc): has skinny extents
>>> [   46.564563] BTRFS info (device vdc): flagging fs with big metadata f=
eature
>>> [   46.587441] BTRFS info (device vdc): checking UUID tree
>>> [   46.766765] BTRFS info (device vdb): disk space caching is enabled
>>> [   46.768197] BTRFS info (device vdb): has skinny extents
>>> [   46.875534] run fstests btrfs/139 at 2018-05-22 18:40:36
>>> [   47.559411] BTRFS: device fsid 065f3825-057e-451f-8722-0d94d4a3f36f =
devid 1 transid 5 /dev/vdc
>>> [   47.612001] BTRFS info (device vdc): disk space caching is enabled
>>> [   47.613254] BTRFS info (device vdc): has skinny extents
>>> [   47.614147] BTRFS info (device vdc): flagging fs with big metadata f=
eature
>>> [   47.632377] BTRFS info (device vdc): checking UUID tree
>>> [   47.681656] btrfs (3176) used greatest stack depth: 12632 bytes left
>>> [   47.691156] ------------[ cut here ]------------
>>> [   47.692084] kernel BUG at fs/btrfs/locking.c:286!
>>
>> I saw the crash too but did not investigate the root cause. So I'll
>> remove the branch from for-next until it's fixed. Thanks for the report.
>=20
> I think the problem stems from Qu's patch, which sets search_commit_root
> =3D1 but doesn't set skip_locking, as a result we don't lock the tree when
> we obtain a reference to the root node, yet later when traversing the
> tree due to skip_locking not being set we try to lock it, and this
> causes btrfs_assert_tree_locked to triggers. Can you test whether the
> following diff solves the issues:
>=20
>=20
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index bc19a7d11c98..23fadb640c59 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -2702,6 +2702,7 @@ static void btrfs_qgroup_rescan_worker(struct
> btrfs_work *work)
>          * should be recorded by qgroup
>          */
>         path->search_commit_root =3D 1;
> +       path->skip_locking =3D 1;
>=20
>         err =3D 0;
>         while (!err && !btrfs_fs_closing(fs_info)) {
>=20
>=20
> If it does, this only means we need to make skip_locking =3D 1 being
> conditional on search_commit_root being set and this situation should be
> handled in btrfs_search_slot.

After patching the change, btrfs/139 passes without BUG_ON.

Thanks,
Su

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20



--------------C508D910112222A89A5EBBB5
Content-Type: application/pgp-keys; name="pEpkey.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="pEpkey.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----=0A=
=0A=
mQENBFrxafoBCADL54g5EnHtuYig32iQtOWgPqZlnBDgdSD+fMxnpMr6zZ7VNT9l=0A=
Pv7BNy4lUHkWff1TbLuZQIoxYKEbmkajwg1rEjBfQ+6RBQWGzsjfprPdEC6kf6Ch=0A=
sVKrfAfJArEgEvkMOCWZE1T5wNl/mNhlWfOYWadfLTIsQCKD5D1PhD9ZgKMwulGn=0A=
OhQfeRuu/X+7zijjrpT1Nvq/Qiya/ANCq7nCu2ZTXDgQR6GSe2qgn0oVC44HKTRl=0A=
PK+47CQ8LFnKeBuTygdOpfAWUi28SCMqwkfZhGtfQQU446HJPNz/bCNRok9l9dZi=0A=
3EEyxMamd/tVmtsOBvtUrYIIIxNAOB87h1+PABEBAAG0IFN1IFl1ZSA8c3V5LmZu=0A=
c3RAY24uZnVqaXRzdS5jb20+iQFUBBMBCAA+FiEE12oP3cNSLnn02mf3AOFqSFGv=0A=
ypwFAlrxafoCGwMFCQHhM4AFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQAOFq=0A=
SFGvypwZaAf8D8gcRk4atpfgKd1nB0UuDcJNPLpzrGxQz3u2UBeNjxGUXsVsQMsy=0A=
Ln+xd/5pbC7tk5D8/+XIZGtLc3Nb0G9D6kdSHjvlpRMo3GtnDJL/kp4TPBlcXM9V=0A=
xzPmbBECdo8Th5+P66H3MNl3S0B48kDEcj5i7M0dZDOeQjKxzt8j++bwEdXVgBvM=0A=
O5W8Qnd5CxbXnjme8/qyJtup1hYAKpf8Yi9bldPM0ri+uWbLtSx8/EvCxsFFMiM+=0A=
zk1fzPqsu+lhI+lBAKR9qvH6mVCictFxA6TM7BH+lcQezHunEJDSO1obLXpjQTwh=0A=
UpU7USyzmE0hx/O2unA6imv1O1fuafCsGLkBDQRa8Wn6AQgAtxCl1ghY/W/lP66b=0A=
27rYgz8otwQ5TaLLwb83qwVOv7AOiMu16ikNcG2Fn0ePj3kv4/iYcsAIq6UHka25=0A=
4UXMdwn8j8lN7dYuuJpFBjW45mHMH9gTNspp456ftqlvgTqJtPmRmcN62IGaI5OD=0A=
/L36v7nMY5iBPecK8hIZd7BFJcBV1jntzy3XTGrvyQXx7LxqIj9uKRj1vTYTLK+9=0A=
uaQFna1+SR7XKtkUg89YObQGXDD3D8qohk9SSmpQGkPPOdC1456Vpn/5FH057W0I=0A=
UC/udC6AKsbYrlEqYihMY0/5FkpTusPOxw+LHpAwJppQ95JNsjtq22HgyFMpGFCW=0A=
bSMMEwARAQABiQE8BBgBCAAmFiEE12oP3cNSLnn02mf3AOFqSFGvypwFAlrxafoC=0A=
GwwFCQHhM4AACgkQAOFqSFGvypwMlQf+NhF3GTn+VE7MgOBJdnYkcp8QjxAJXRVp=0A=
T9QHcJj37BiNJbCxKIac35rFsPe8BaFDM+W6aqe5+zayVd2Zx771imCbimCqgtTB=0A=
/ScbarN/fgTP1sodDBuVLJmJWPIisYrX4jQx26OfbnZHNYKEHumh5+YghSnNGd6U=0A=
zS/F+k2PEQZ6rbGQeyHYNDegzq7Nieg9aNoV7qvPAwbG/9KrXBQdh+X0w1Fs/Gye=0A=
wi1vrOIWtTE2ORTJZb8y76wy6M6oOWv2PnQ0TLHM+8wTTX+dgU/IjQNO6ikqLqI8=0A=
PN8qtLmiy6GAQETDZO//XSxcpHQJVIU/+jHKZYuHJ1IMCcaC9vvjzg=3D=3D=0A=
=3DDxgD=0A=
-----END PGP PUBLIC KEY BLOCK-----=0A=

--------------C508D910112222A89A5EBBB5--
