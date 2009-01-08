From: "Yan Zheng" <yanzheng@21cn.com>
Subject: Re: What's wrong with snapshot?
Date: Thu, 8 Jan 2009 19:49:19 +0800
Message-ID: <3d0408630901080349k5130ba6as11a48c4e7a6c19b5@mail.gmail.com>
References: <4965C718.8070200@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Shen Feng" <shen@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4965C718.8070200@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

2009/1/8 Shen Feng <shen@cn.fujitsu.com>:
> Hello,
>
> I tried to ceate a snapshot of a subvol.
> But it seems now work.
>
> Please see the test below. I think the file created by dd
> should also in the snap directory.
>

This is the expected behaviour.  Following link describes what
snapshot is.

http://en.wikipedia.org/wiki/Snapshot_(computer_storage)

Yan Zheng
