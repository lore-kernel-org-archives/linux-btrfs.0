From: Piavlo <piavka@cs.bgu.ac.il>
Subject: Re: snapshot/subvolume removal
Date: Tue, 12 Jan 2010 09:08:26 +0200
Message-ID: <4B4C1FEA.70109@cs.bgu.ac.il>
References: <4B43AC9B.5030109@cs.bgu.ac.il> <4B43D9AB.1090606@jp.fujitsu.com> <4B444AD5.1060501@cs.bgu.ac.il> <4B46ECBA.2030402@jp.fujitsu.com> <4B48FCCC.9050004@cs.bgu.ac.il> <4B4BC6D2.6030906@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B4BC6D2.6030906@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

TARUISI Hiroaki wrote:
> Thanks for your comment.
>
> I think your request is reasonable but because there's
> no information about a hierachy of snapshots in filesystem,
> we cannot know it for now.
>
> In future, these information may be supplied by application
> programs which manage all snapshots or backups.
>   
Maintaining snapshot hierarchy by  external application is not reliable
and error prone
compared to maintaining it withing the btrfs itself,
probably by adding the parent treeid field for every  shapshot/subvolume.

Thanks
Alex

