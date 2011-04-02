From: Viacheslav Dobromyslov <slavik.dobro@gmail.com>
Subject: Re: another messed-up btrfs
Date: Sat, 2 Apr 2011 00:05:54 +0000
Message-ID: <AANLkTinSArPPoqUZk9X8j=um-VBB0ad_Kyi6UT6_Utqe@mail.gmail.com>
References: <20110401194713.6990@gmx.net>
	<20110401200147.23440.qmail@stuge.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110401200147.23440.qmail@stuge.se>
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

Still waiting for this
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg08370.html

Sincerely,
Viacheslav Dobromyslov



On Fri, Apr 1, 2011 at 8:01 PM, Peter Stuge <peter@stuge.se> wrote:
> Martin Fahr wrote:
>> btrfsck: disk-io.c:741: open_ctree_fd: Assertion `!(!tree_root->node=
)' failed.
>
> My fs is also broken this way, though for me it happened after
> resizing the fs and then partition. I still need to go back to the
> list thread and do some work on my image.
>
>
>> The usual questions: Is there anything I could do to help analyze
>> and fix the problem? Is there hope to restore the data any time
>> soon, or should I better use the backup I have (and possibly move
>> to an ext4 file system)?
>
> It seems the root node is a bit of a sore point with btrfs. :\
>
>
> //Peter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
