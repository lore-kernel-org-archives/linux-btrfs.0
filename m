From: Chester <somethingsome2000@gmail.com>
Subject: Re: Create subvolume from a directory?
Date: Tue, 27 Mar 2012 15:42:11 -0500
Message-ID: <CAAE6i0iK48WF9t6svoOcK=LRjtbAgUPzTeQBDBUWwVAwUqVHYg@mail.gmail.com>
References: <loom.20120327T190041-268@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Alex <alex@bpmit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20120327T190041-268@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 27, 2012 at 12:19 PM, Alex <alex@bpmit.com> wrote:
> Hi all,
>
> Just a quick question but can't find an obvious answer.
>
> Can I create/convert a existing (btrfs) directory into a subvolume?
>
> It would be very helpful when transferring 'partitions' into btrfs.
> I found a similar question way back in google, but that site is
> down now generally.
>
> Thanks in advance.
>
>

I don't think this is possible. The closest thing I can think of is to
take a snapshot of the volume, move the directory to the top of the
subvolume, then delete all other content..

=2E.. That seems like an awful amount of work, but it'll preserve the
contents of the directory without making duplicates.

>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
