From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: snapshot/subvolume removal
Date: Fri, 08 Jan 2010 17:28:42 +0900
Message-ID: <4B46ECBA.2030402@jp.fujitsu.com>
References: <4B43AC9B.5030109@cs.bgu.ac.il> <4B43D9AB.1090606@jp.fujitsu.com> <4B444AD5.1060501@cs.bgu.ac.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: piavka@cs.bgu.ac.il
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B444AD5.1060501@cs.bgu.ac.il>
List-ID: <linux-btrfs.vger.kernel.org>

For now, subvolumes and snapshots look like just directories.
If you want to distinguish them, there's only an unusual way,
that is, analyzing with btrfs-debug-tree.

I posted patches for listing snapshots/subvolumes two months ago,
and Josef Bacik posted its bugfix patch. This feature may be
delivered in sooner or later.
If you want to try it now, check these URLs.
  http://patchwork.kernel.org/patch/60923/raw/
  http://patchwork.kernel.org/patch/60920/raw/
  http://patchwork.kernel.org/patch/67332/raw/
Patches and requests are welcome.

Regards,
taruisi

(2010/01/06 17:33), Piavlo wrote:
> TARUISI Hiroaki wrote:
>> Hi,
>>
>> We can delete snapshot with btrfsctl -D . It's available for
>> your btrfs-progs version.
> -D works great
> 
> Also how can I know if some directory is subvolume or snapshot or just a
> normal directory?
> Is there a way to list all the existing snapshots & subvolumes under btrfs?
> 
> Thanks
> Alex
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

