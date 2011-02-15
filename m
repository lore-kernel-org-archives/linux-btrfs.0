From: =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>
Subject: Re: btrfs: compression breaks cp and cross-FS mv, FS_IOC_FIEMAP bug?
Date: Tue, 15 Feb 2011 11:30:38 +0000
Message-ID: <4D5A63DE.3040600@draigBrady.com>
References: <AANLkTinZNk1j94rEMVdvRtjr2Sa-C7VpQOGHrvrY8Hph@mail.gmail.com> <20110213155730.GK19533@dhcp231-156.rdu.redhat.com> <AANLkTi=Rj_3MmLawJj-K8u+pGbT_NZzqzVGFOsvOK8eC@mail.gmail.com> <20110213161329.GL19533@dhcp231-156.rdu.redhat.com> <1297695521-sup-9460@think> <AANLkTi=N8DiusfP6Rey=Cx4qjUSbiLS3jnbjASGQ=Lcx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	btrfs hackers <linux-btrfs@vger.kernel.org>,
	Kernel hackers <linux-kernel@vger.kernel.org>,
	8001@debbugs.gnu.org
To: Marti Raudsepp <marti@juffo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=N8DiusfP6Rey=Cx4qjUSbiLS3jnbjASGQ=Lcx@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 14/02/11 17:58, Marti Raudsepp wrote:
> On Mon, Feb 14, 2011 at 17:01, Chris Mason <chris.mason@oracle.com> w=
rote:
>> Or, it could just be delalloc ;)
>=20
> I suspect delalloc. After creating the file, filefrag reports "1
> extent found", but for some reason it doesn't actually print out
> details of the extent.

That's a bug in `filefrag -v` that I noticed independently yesterday.
Without -v it will correctly report 0 extents.
I've already suggested a patch to fix upstream.

> After a "sync" call, the extent appears and "cp" starts working as ex=
pected:

About that sync.
I've noticed on ext4 loop back at least (and I suspect BTRFS is the sam=
e)
that specifying FIEMAP_FLAG_SYNC (which cp does) is ineffective.
I worked around this for cp tests by explicitly syncing with:
dd if=3D/dev/null of=3Dfoo conv=3Dnotrunc,fdatasync

> % rm -f foo bar
> % echo foo > foo
> % sync
> % filefrag -v foo
> Filesystem type is: 9123683e
> File size of foo is 4 (1 block, blocksize 4096)
>  ext logical physical expected length flags
>    0       0        0            4096 not_aligned,inline,eof
> foo: 1 extent found
> % cp foo bar
> % hexdump bar
> 0000000 6f66 0a6f
> 0000004

OK that's fine for normal files.
cp (from coreutils >=3D 8.10) may still do the wrong thing
as it currently ignores FIEMAP_EXTENT_DATA_ENCRYPTED and FIEMAP_EXTENT_=
ENCODED
as I've already reported:
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg08356.html
I'd appreciate some `filefrag -v` output from a large compressed file.

cheers,
P=C3=A1draig.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
