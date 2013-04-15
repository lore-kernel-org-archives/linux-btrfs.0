Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:49535 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab3DOOKx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Apr 2013 10:10:53 -0400
Received: by mail-oa0-f45.google.com with SMTP id o6so4482067oag.18
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Apr 2013 07:10:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMQ-g0eYL7Ab0cETWJW66-9e_qzgRR+Kyd++kk4fzD1m464aZg@mail.gmail.com>
References: <1366033629-25121-1-git-send-email-danmcgrath.ca@gmail.com>
	<1366033629-25121-2-git-send-email-danmcgrath.ca@gmail.com>
	<CAMQ-g0eYL7Ab0cETWJW66-9e_qzgRR+Kyd++kk4fzD1m464aZg@mail.gmail.com>
Date: Mon, 15 Apr 2013 10:10:53 -0400
Message-ID: <CAK82gMEV-1rBoDjESXtiHGWtpbhEJLciuAAo1vqzyrY8J7L5gQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: No-op when called as fsck.btrfsck
From: Dan McGrath <danmcgrath.ca@gmail.com>
To: Jan Alexander Steffens <jan.steffens@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My sincere apologies. It would appear that I was overly careful about
checking the binary functioned when called as a symlink, but not the
correct filename:

  # ls -l `which fsck.btrfs`
  lrwxrwxrwx 1 root root 7 Aug 25  2011 /sbin/fsck.btrfs -> btrfsck

So yes, the patch incorrectly assumed a symlink name of
'fsck.btrfsck', instead of 'fsck.btrfs'.

As for fsck.xfs, I will take a look, thanks!


On Mon, Apr 15, 2013 at 10:03 AM, Jan Alexander Steffens
<jan.steffens@gmail.com> wrote:
>
> On Mon, Apr 15, 2013 at 3:47 PM, Dan McGrath <danmcgrath.ca@gmail.com> wrote:
> > As per FAQ: It is safe to and recommended to turn fsck.btrfs into a no-op
> >
> > Signed-off-by: Dan McGrath <danmcgrath.ca@gmail.com>
> > ---
> >  btrfs.c |    2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/btrfs.c b/btrfs.c
> > index 691adef..78161a9 100644
> > --- a/btrfs.c
> > +++ b/btrfs.c
> > @@ -272,6 +272,8 @@ int main(int argc, char **argv)
> >
> >         if (!strcmp(bname, "btrfsck")) {
> >                 argv[0] = "check";
> > +       } else if (!strcmp(bname, "fsck.btrfsck")) {
> > +               exit(0);
> >         } else {
> >                 argc--;
> >                 argv++;
> > --
> > 1.7.9.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Shouldn't it be fsck.btrfs, not fsck.btrfsck?
>
> Also, fsck.xfs does a bit more than just an exit(0), maybe there's
> some merit to what it does. It's a simple shellscript, so check it
> out.
