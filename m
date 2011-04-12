From: cwillu <cwillu@cwillu.com>
Subject: Re: Kernel BUG at fs/btrfs/inode.c:2281 & 4665
Date: Tue, 12 Apr 2011 09:29:43 -0600
Message-ID: <BANLkTim8OsPEodhgq5+6bg3E8jKWTOoyeA@mail.gmail.com>
References: <4931fe2bc7e70ddc21f0240f9b65bb29.squirrel@squirrel-webmail.surftown.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: maria@ponstudios.se
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4931fe2bc7e70ddc21f0240f9b65bb29.squirrel@squirrel-webmail.surftown.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 12, 2011 at 9:11 AM,  <maria@ponstudios.se> wrote:
>
> The computer was idle when the first bug happened and after the reboot
> btrfs can't be mounted. It can't delete orphans and replay the log.
> It would be nice if I can get the data out, there is nothing important
> there but it would be nice. I was actually fixing typos in the backup
> scripts when the bug attacked :)

There's a "btrfs-zero-log" in the progs-unstable git repository that
will probably get you up and running again.  You have to build it
manually via "make btrfs-zero-log".

> I have written this by hand so there may be typos. I skipped the parts
> that I don't think is necessary, the rest is on paper if I missed
> something important.

Digital cameras are wonderful things :p
