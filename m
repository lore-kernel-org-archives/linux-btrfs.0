Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:49445 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956AbaAHAfW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jan 2014 19:35:22 -0500
Received: by mail-la0-f53.google.com with SMTP id mc6so654858lab.40
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Jan 2014 16:35:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140106153602.GW6498@twin.jikos.cz>
References: <1388585425-7051-1-git-send-email-vitoux.pascal@gmail.com>
	<20140106153602.GW6498@twin.jikos.cz>
Date: Wed, 8 Jan 2014 01:35:20 +0100
Message-ID: <CA+Tae6d2f-GT9s2qtKhPJph=TVTKsFi+g5c19Q9NB3+0D=iU1A@mail.gmail.com>
Subject: Re: [PATCH] Skip non-regular files in recursive defrag
From: Pascal VITOUX <vitoux.pascal@gmail.com>
To: dsterba@suse.cz, Pascal VITOUX <vitoux.pascal@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 6, 2014 at 4:36 PM, David Sterba <dsterba@suse.cz> wrote:
>
> On Wed, Jan 01, 2014 at 03:10:25PM +0100, Pascal VITOUX wrote:
> > ---
> >  cmds-filesystem.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/cmds-filesystem.c b/cmds-filesystem.c
> > index 1c1926b..979dbd9 100644
> > --- a/cmds-filesystem.c
> > +++ b/cmds-filesystem.c
> > @@ -646,7 +646,7 @@ static int defrag_callback(const char *fpath, const struct stat *sb,
> >       int e = 0;
> >       int fd = 0;
> >
> > -     if (typeflag == FTW_F) {
> > +     if ((typeflag == FTW_F) && S_ISREG(sb->st_mode)) {
>
> The ftw(3) documentation states that FTW_F gets the regular files, do you have a
> reproducer whre this does not work as expected?

Yes, this can be tested with the example code provided in ftw(3) and
compiled with glibc 2.18.

In fact, the ftw(3) page also states in the NOTES part that, under
Linux, FTW_F is used for all objects that are not a directory. Some
libc versions are specified ( libc4, libc5 and glic 2.0.6 ) but it's
still true in glibc 2.18

The ftw's man page is less precise than the libc manual, as you can
see here : http://www.gnu.org/software/libc/manual/html_node/Working-with-Directory-Trees.html

> I think the check could be placed into cmd_defrag, there's a st_mode
> check for directories already. Defragmenting makes most sense for
> regular files (though there's the option to defrag portions of the
> metadata b-trees), so it's fine to handle just directories and regular
> files in userspace.

I think so, too. And for a single file defrag the check should return
to the user an explicit error message instead of the 'defrag range
ioctl not supported'  error.

> If you're going to resend the patch, please add 'btrfs-progs: ' string
> to the subject, write a short changlog and add your Signed-off-by line.
>
> thanks,
> david

Ok, thanks for these instructions. I will resend it soon.

Pascal.
