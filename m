Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from walhalla.sjomar.eu ([141.105.125.198]:50100 "EHLO
	walhalla.sjomar.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbbFMPBh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 13 Jun 2015 11:01:37 -0400
Received: from hoefnix.localnet (a83-163-227-207.adsl.xs4all.nl [83.163.227.207])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: sjoerd@sjomar.eu)
	by walhalla.sjomar.eu (Postfix) with ESMTPSA id 2E9CB1000EA
	for <linux-btrfs@vger.kernel.org>; Sat, 13 Jun 2015 17:01:33 +0200 (CEST)
From: Sjoerd <sjoerd@sjomar.eu>
To: BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs filesystem show confused when label is same as mountpoint
Date: Sat, 13 Jun 2015 17:01:30 +0200
Message-ID: <95632858.dF9LzaHtr5@hoefnix>
In-Reply-To: <557BFCCD.6060202@oracle.com>
References: <557BFCCD.6060202@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 13 June 2015 17:50:05 Anand Jain wrote:
> I don't see that in 4.0, could you upgrade/try. thanks
> 

That works fine indeed! Thanks....Could have thought to try that first myself ;)


> ---------------
> mount /dev/sdf /data/Multimedia
> 
> btrfs fi show /data/Multimedia
> Label: 'MULTIMEDIA'  uuid: 9b49bcc9-66d9-4f76-a57a-a60e2a16f15d
> 	Total devices 1 FS bytes used 192.00KiB
> 	devid    1 size 2.90GiB used 333.12MiB path /dev/sdf
> 
> btrfs-progs v4.0.1-2-ge8ceb61
> 
> btrfs fi show MULTIMEDIA
> Label: 'MULTIMEDIA'  uuid: 9b49bcc9-66d9-4f76-a57a-a60e2a16f15d
> 	Total devices 1 FS bytes used 192.00KiB
> 	devid    1 size 2.90GiB used 333.12MiB path /dev/sdf
> 
> btrfs-progs v4.0.1-2-ge8ceb61
> ---------------
> 
> Anand
> 
> 
> On 06/13/2015 03:20 PM, Sjoerd wrote:> Hi,
> 
>  > I've a btrfs partition with label 'MULTIMEDIA' (all capitals) and
> 
> mounted it
> 
>  > on /data/Multimedia (only M capital) and see the following when doing
> 
> a btrfs
> 
>  > fi show:
>  > 
>  > for mountpoint:
>  > btrfs fi show /data/Multimedia
>  > Btrfs v3.17
>  > 
>  > versus for label:
>  > btrfs fi show MULTIMEDIA
>  > Label: 'MULTIMEDIA'  uuid: ce5d23cd-73a4-4f7c-83cd-2c40d12f6697
>  > 
>  >          Total devices 4 FS bytes used 5.04TiB
>  >          devid    1 size 1.48TiB used 1.26TiB path /dev/sda2
>  >          devid    2 size 1.48TiB used 1.26TiB path /dev/sdc2
>  >          devid    3 size 1.48TiB used 1.26TiB path /dev/sdd2
>  >          devid    4 size 1.48TiB used 1.26TiB path /dev/sde2
>  > 
>  > So in the latter case I get the results I was looking for.
>  > 
>  > 
>  > It's not realy a question, but I couldn't find anything on the
> 
> bugtracker (if
> 
>  > it's a bug in the first place) or a known something, so just to let you
>  > know,cause I took me awhile to figure out why I didn't get results
> 
> for this
> 
>  > particular mountpoint, while for others I did ;)
>  > 
>  > Cheers,
>  > Sjoerd
>  > 
>  > --
>  > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>  > the body of a message to majordomo@vger.kernel.org
>  > More majordomo info at  http://vger.kernel.org/majordomo-info.html

