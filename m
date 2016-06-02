Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:38112 "EHLO
	mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbcFBEvN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2016 00:51:13 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 9D862AC02F0
	for <linux-btrfs@vger.kernel.org>; Thu,  2 Jun 2016 13:50:46 +0900 (JST)
Subject: Re: Very quick embarrassing q: /var/lib permissions.
To: al <6401e46d@opayq.com>, linux-btrfs@vger.kernel.org
References: <loom.20160531T234453-643@post.gmane.org>
 <d0551873-1579-66b1-08c5-d002e721612f@jp.fujitsu.com>
 <loom.20160602T031625-163@post.gmane.org>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <b59606d4-c9ec-5dc5-3c04-2d3d52b13809@jp.fujitsu.com>
Date: Thu, 2 Jun 2016 13:50:37 +0900
MIME-Version: 1.0
In-Reply-To: <loom.20160602T031625-163@post.gmane.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/06/02 10:20, al wrote:
> Satoru Takeuchi <takeuchi_satoru <at> jp.fujitsu.com> writes:
> <snip>
>
> Thank you, sir!
>
> I wonder if you would let me have the permissions (only) of any of the files
> you have inside your equivalent directory.

Here it is.

===================
# ls -l /var/lib/btrfs/
total 4
-rw-------. 1 root root 413 Jun  1 08:19 scrub.status.<FSID>
===================

>
> Effectively I'm asking (for evidence) if I'm using the command with
> escalated permissions when this is unnecessary.

I wonder why you ask these question.
Probably it's enough to read the file permissions of
your system...

Thanks,
Satoru

>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
