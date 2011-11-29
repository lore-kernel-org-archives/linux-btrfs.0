From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: btrfs/git question.
Date: Tue, 29 Nov 2011 09:33:37 +0700
Message-ID: <CAG1y0scuoKwH_MbQPGQKr5sYAXP_kB=j6FOMHgm2=EzPwAVL=Q@mail.gmail.com>
References: <af6c5f5cb5a1778a8d811e8293dfdd73@www.jots.org>
	<4ED43C30.50502@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: "Ken D'Ambrosio" <ken@jots.org>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4ED43C30.50502@cfl.rr.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 29, 2011 at 8:58 AM, Phillip Susi <psusi@cfl.rr.com> wrote:
> On 11/28/2011 12:53 PM, Ken D'Ambrosio wrote:
>> Seems I've picked up a wireless regression, and randomly drop my WiF=
i
>> connection with more recent kernels. =A0While I'd love to try to tra=
ck down the
>> issue, the sporadic nature makes it difficult. =A0But I don't want t=
o revert to a
>> flat-out old kernel because of all the btrfs modifications. =A0Is it=
 possible
>> using git to add *just* btrfs patches to an older kernel?
>
> Sure: use git rebase to apply the patches to the older kernel.

=2E.. or use 3.1.2, and get ONLY fs/btrfs from Chris' for-linus tree,
compile it out-of-tree, and use it to replace the original btrfs.ko.

There used to be this:
https://btrfs.wiki.kernel.org/articles/b/t/r/Btrfs_source_repositories.=
html#Building_latest_btrfs_against_a_recent_kernel_with_DKMS

But personally it's much easier to just compile it manually without dkm=
s:
make -C /llib/modules/`uname -r`/build M=3D$(pwd) modules

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
