Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:33005 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1164825AbdD1KDs (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Apr 2017 06:03:48 -0400
Received: by mail-ua0-f194.google.com with SMTP id z29so521932uab.0
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Apr 2017 03:03:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170428095530.yw74untb34oawlm2@mailbox.org>
References: <CAKuJGC9hJSKnHrXPr2EvEktjHf-=OxJkhzzZbeFfB6OUYSdyJQ@mail.gmail.com>
 <20170428095530.yw74untb34oawlm2@mailbox.org>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Fri, 28 Apr 2017 15:33:06 +0530
Message-ID: <CAKuJGC88jCxHBz6eTNK-F-fsuBzw4jRsDucEYqgPRKrgR8TWWA@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] btrfs-progs: fix btrfs send & receive with -e flag
To: Christian Brauner <christian.brauner@canonical.com>, nazar@mokrynskyi.com
Cc: Christian Brauner <christian.brauner@ubuntu.com>, dsterba@suse.cz,
        btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

Adding the bug reporter, Nazar for the discussion (as I'm not familiar
with send/receive feature/code).

----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org

On Fri, Apr 28, 2017 at 3:25 PM, Christian Brauner
<christian.brauner@canonical.com> wrote:
>
> Hi,
>
> On Fri, Apr 28, 2017 at 02:55:31PM +0530, Lakshmipathi.G wrote:
> > Seems like user reported an issue with this patch. please check
> > https://bugzilla.kernel.org/show_bug.cgi?id=195597
>
> I can take a look. What I'm wondering about is why it fails only in the HDD
> to SSD case. If -ENODATA is returned with this patch it should mean that there
> was no header data. So is the user sure that this doesn't indicate a valid
> error?
>
> Christian
>
> >
> > ----
> > Cheers,
> > Lakshmipathi.G
> >
> >
> > On Tue, Apr 4, 2017 at 1:51 AM, Christian Brauner <
> > christian.brauner@ubuntu.com> wrote:
> > > The old check here tried to ensure that empty streams are not considered
> > valid.
> > > The old check however, will always fail when only one run through the
> > while(1)
> > > loop is needed and honor_end_cmd is set. So this:
> > >
> > > btrfs send /some/subvol | btrfs receive -e /some/
> > >
> > > will consistently fail because -e causes honor_cmd_to be set and
> > > btrfs_read_and_process_send_stream() to correctly return 1. So the
> > command will
> > > be successful but btrfs receive will error out because the send - receive
> > > concluded in one run through the while(1) loop.
> > >
> > > If we want to exclude empty streams we need a way to tell the difference
> > between
> > > btrfs_read_and_process_send_stream() returning 1 because read_buf() did
> > not
> > > detect any data and read_and_process_cmd() returning 1 because
> > honor_end_cmd was
> > > set. Without introducing too many changes the best way to me seems to have
> > > btrfs_read_and_process_send_stream() return -ENODATA in the first case.
> > The rest
> > > stays the same. We can then check for -ENODATA in do_receive() and report
> > a
> > > proper error in this case. This should also be backwards compatible to
> > previous
> > > versions of btrfs receive. They will fail on empty streams because a
> > negative
> > > value is returned. The only thing that they will lack is a nice error
> > message.
> > >
> > > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > > ---
> > > Changelog: 2017-04-03
> > >         - no changes
> > > ---
> > >  cmds-receive.c | 13 +++++--------
> > >  send-stream.c  |  2 +-
> > >  2 files changed, 6 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/cmds-receive.c b/cmds-receive.c
> > > index 6cf22637..b59f00e4 100644
> > > --- a/cmds-receive.c
> > > +++ b/cmds-receive.c
> > > @@ -1091,7 +1091,6 @@ static int do_receive(struct btrfs_receive *rctx,
> > const char *tomnt,
> > >         char *dest_dir_full_path;
> > >         char root_subvol_path[PATH_MAX];
> > >         int end = 0;
> > > -       int count;
> > >
> > >         dest_dir_full_path = realpath(tomnt, NULL);
> > >         if (!dest_dir_full_path) {
> > > @@ -1186,7 +1185,6 @@ static int do_receive(struct btrfs_receive *rctx,
> > const char *tomnt,
> > >         if (ret < 0)
> > >                 goto out;
> > >
> > > -       count = 0;
> > >         while (!end) {
> > >                 if (rctx->cached_capabilities_len) {
> > >                         if (g_verbose >= 3)
> > > @@ -1200,16 +1198,15 @@ static int do_receive(struct btrfs_receive *rctx,
> > const char *tomnt,
> > >                                                          rctx,
> > >
> >  rctx->honor_end_cmd,
> > >                                                          max_errors);
> > > -               if (ret < 0)
> > > -                       goto out;
> > > -               /* Empty stream is invalid */
> > > -               if (ret && count == 0) {
> > > +               if (ret < 0 && ret == -ENODATA) {
> > > +                       /* Empty stream is invalid */
> > >                         error("empty stream is not considered valid");
> > >                         ret = -EINVAL;
> > >                         goto out;
> > > +               } else if (ret < 0) {
> > > +                       goto out;
> > >                 }
> > > -               count++;
> > > -               if (ret)
> > > +               if (ret > 0)
> > >                         end = 1;
> > >
> > >                 close_inode_for_write(rctx);
> > > diff --git a/send-stream.c b/send-stream.c
> > > index 5a028cd9..78f2571a 100644
> > > --- a/send-stream.c
> > > +++ b/send-stream.c
> > > @@ -492,7 +492,7 @@ int btrfs_read_and_process_send_stream(int fd,
> > >         if (ret < 0)
> > >                 goto out;
> > >         if (ret) {
> > > -               ret = 1;
> > > +               ret = -ENODATA;
> > >                 goto out;
> > >         }
> > >
> > > --
> > > 2.11.0
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
