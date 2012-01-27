From: Wes <anomaly256@gmail.com>
Subject: Re: btrfs filesystem df command oddly named?
Date: Fri, 27 Jan 2012 13:06:38 +1100
Message-ID: <CAHH42iuWHH-ezUdLSzHpcqr9G69a1NdY_m4GGOmjn2jxoQwxdQ@mail.gmail.com>
References: <CAHH42ivUik8NeT=h-AHQ9WwTZmpuN7BqyeN=ZNHM8RpjKu+-mg@mail.gmail.com>
	<CAAE6i0jy1wHV-7CZinK7qsCOxuLZXW7dcVRuBgdvkHQKsWEMsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chester <somethingsome2000@gmail.com>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAE6i0jy1wHV-7CZinK7qsCOxuLZXW7dcVRuBgdvkHQKsWEMsg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> I don't know much of what goes on inside BtrFS, but I like to point
> out that btrfs fi df doesn't actually report total space on the disk,
> only the total space currently allocated.


Good point, and this also supports the notion that it's more of a 'du'
work-alike than a 'df' one
