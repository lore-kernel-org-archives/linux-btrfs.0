From: Chester <somethingsome2000@gmail.com>
Subject: Re: btrfs filesystem df command oddly named?
Date: Thu, 26 Jan 2012 19:52:31 -0600
Message-ID: <CAAE6i0jy1wHV-7CZinK7qsCOxuLZXW7dcVRuBgdvkHQKsWEMsg@mail.gmail.com>
References: <CAHH42ivUik8NeT=h-AHQ9WwTZmpuN7BqyeN=ZNHM8RpjKu+-mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Wes <anomaly256@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAHH42ivUik8NeT=h-AHQ9WwTZmpuN7BqyeN=ZNHM8RpjKu+-mg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 26, 2012 at 7:11 PM, Wes <anomaly256@gmail.com> wrote:
> Just wondering,
>
> Why is this command called 'df' when it reports total space and used
> space but not free space? =A0Wouldn't this be more aptly named 'btrfs
> filesystem du' =A0?
> It's been my understanding that traditionally 'df' has been to displa=
y
> free space remaining (as well as total available and used, but with
> the focus being on free space. =A0The 'df' man page indicates this as
> well.)
I don't know much of what goes on inside BtrFS, but I like to point
out that btrfs fi df doesn't actually report total space on the disk,
only the total space currently allocated.
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
