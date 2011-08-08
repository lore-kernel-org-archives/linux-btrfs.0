From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Why does fsck returns "unresolved ref root"
Date: Mon, 8 Aug 2011 09:25:50 +0700
Message-ID: <CAG1y0scedcxOWgJzvUr3g4Wa_6OQYCKxeAwYiWjx=rqOzZhE6g@mail.gmail.com>
References: <877h6okd14.fsf@invalid.clx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <877h6okd14.fsf@invalid.clx>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 8, 2011 at 6:38 AM,  <dclist@gmail.com> wrote:
>
> On my system btrfsck runs periodically at boot. When it is run I get the
> error message "unresolved ref root" in reference to a snapshot I
> created. Consequently the fsck gets re-run during the following boot
> repeating a time consuming process. I can disable fsck but I would like
> to fix any issues with my filesystem.
>
> How do I diagnose the problem? The snapshot seems to function correctly
> when the filesystem is mounted. I do not remember the details of how I
> created the snapshot.

Current btrfsck does not fix anything, so it's easiest to just disable
it on /etc/fstab (set the last character on "/" line to "0").

When new btrfsck is released you might want to try checking again.

-- 
Fajar
