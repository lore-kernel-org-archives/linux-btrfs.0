From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: [3.2.1] BUG at fs/btrfs/inode.c:1588
Date: Sun, 05 Feb 2012 09:01:25 +0100
Message-ID: <pjp109-kdo.ln1@hurikhan.ath.cx>
References: <vqfmv8-9ch.ln1@hurikhan.ath.cx> <82ivv8-dsn.ln1@hurikhan.ath.cx> <CAKcLGm_=bRf7g+ezE7OBRNka57Z_NcofkMW-XkGmC1jAFv0gyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Mitch Harder <mitch.harder@sabayonlinux.org> schrieb:

> On Sat, Feb 4, 2012 at 5:40 AM, Kai Krakow <hurikhan77+btrfs@gmail.com>
> wrote:
>> It's actually the case for me that rsync writes to the device using mount
>> options "compress-force=zlib" and that rsync probably truncates files
>> sometimes when using the inplace option.
>>
>> So that occurence is explained. Can anyone tell how bad it is to have
>> this error? May the fs explode at some point or is it just an error I
>> could safely ignore for the moment?
>>
>> And what about the "inode errors 2000"? What's the 2000 standing for?
>>
> 
> As I understand it, Miao Xie's "Btrfs: fix btrfsck error 400 when
> truncating a compressed" patch was intended to address only one
> scenario that would lead to 400 errors.  It was not intended to
> comprehensively address problems that generate inode 400 errors, nor
> will this patch fix the error once it encountered.

I already understood that this patch wont magically fix errors already on 
disk. But my hope is, in 3.3, it would not introduce such errors any longer. 
But from what you write it could still generate inode 400 errors?

I conclude that there exist many points in the btrfs code which could 
generate inode 400 errors, and Miao Xie's patch only fixes the one scenario 
about truncating compressed files? Well, that should at least fix the 
problems for me because I believe this is coming from using compress-force 
with rsync-inplace... I don't think these errors are originating from 
somewhere else because this disk is only mounted for the few minutes I'm 
running the rsync to it, then unmounted. Any maybe 3-4 weeks ago there have 
been no errors in btrfsck...

> As it stands right now, if you have errors reported by btrfsck, and
> you've exhausted the tools available for addressing errors (scrub and
> zero-ing out the log are the only two I know of),

I think I will try btrfs-repair from Josef... That's one other tool for 
addressing errors.

> you only really have
> two options (until further tools such as btrfsck are released):
> 
> (1)  Run with the errors and cross your fingers.

I don't like crossing fingers for computers... ;-)

> (2)  Backup and restore onto a freshly formatted  volume (there are
> some new tools available to extract data if you encounter errors).

This is my backup disk so I could easily purge it and restart with a backup 
from scratch - it will just take some hours for the first sync.

> My personal preference is to backup and restore.

This is why I got this external backup disk. ;-)

> With respect to the error codes, you have to look in the source for
> btrfsck.c.  Inode errors are defined as I_ERR_<error>.
> 
> 0x400 (1 << 8) errors are I_ERR_FILE_NBYTES_WRONG
> 0x2000 (1 << 13) errors are I_ERR_LINK_COUNT_WRONG

Thanks for the pointers. I probably could live with the wrong link count. 
Not sure what kind of problems and wrong nbytes value introduces but at 
least my latest snapshot seems to be okay. Well, and at least these kind of 
errors seem like a proper candidate for btrfs-repair from Josef's btrs-progs 
tree.

> The 400 inode errors have been common lately.  I haven't seen as many
> 2000 inode errors.

I report back if btrfs-repair could fix it for me...

Thanks,
Kai

