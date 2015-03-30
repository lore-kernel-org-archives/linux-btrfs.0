Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.miceliux.com ([37.247.55.143]:60965 "EHLO mx2.miceliux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751086AbbC3GQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Mar 2015 02:16:52 -0400
Received: from mx1.miceliux.com (unknown [188.164.129.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: relay)
	by mx2.miceliux.com (Postfix) with ESMTPSA id E1474181AFC
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2015 08:16:48 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mx1.miceliux.com (Postfix) with ESMTP id BFA96621C9
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2015 08:16:47 +0200 (CEST)
Received: from mx1.miceliux.com ([127.0.0.1])
	by localhost (mx1.miceliux.com [127.0.0.1]) (amavisd-new, port 10028)
	with ESMTP id WWjKvYYhCExq for <linux-btrfs@vger.kernel.org>;
	Mon, 30 Mar 2015 08:16:45 +0200 (CEST)
Received: from miceliux.com (charm.miceliux.com [IPv6:2a00:dcc0:dead:a94b::1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: juan.orti@miceliux.com)
	by mx1.miceliux.com (Postfix) with ESMTPSA id A34C5621D2
	for <linux-btrfs@vger.kernel.org>; Mon, 30 Mar 2015 08:16:45 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 30 Mar 2015 08:16:44 +0200
From: Juan Orti Alcaine <juan.orti@miceliux.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Cannot convert to raid1
In-Reply-To: <pan.2015.03.29.20.04.09@googlemail.com>
References: <1427656526.2251.8.camel@miceliux.com>
 <CAJCQCtQLPj2n=jO+s3z28_SdYL1mz97FBntK-0YLYn112EKBNg@mail.gmail.com>
 <pan.2015.03.29.20.04.09@googlemail.com>
Message-ID: <a713705efd7fb91a19f773253c34b426@miceliux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

El 2015-03-29 22:04, Holger Hoffstätte escribió:
> On Sun, 29 Mar 2015 13:40:56 -0600, Chris Murphy wrote:
> 
>> On Sun, Mar 29, 2015 at 1:15 PM, Juan Orti Alcaine
>> <juan.orti@miceliux.com> wrote:
>> 
>>> The filesystem was created with one device, and I have added two more
>>> devices afterwards. To convert it to raid1, I have used:
>>> 
>>> # btrfs balance start -dconvert=raid1 -mconvert=raid1 
>>> /mnt/btrfs_raid1
>> 
>>> The balance process has finished, but if I check my filesystem, it
>>> shows up as single
>> 
>> Yeah, I'm kinda stumped. The only thing I'm thinking is if you're
>> absolutely sure it's mounted at /mnt/btrfs_raid1 – because I've made
>> this mistake before. (Oops.)
> 
> Nope, known bug in 4.0-rc:
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/43117


Do you know if the fix is going to do it for 4.0 final?
Thank you.

-- 
Juan Orti
https://miceliux.com

GPG key: https://miceliux.com/pub/pubkey.asc
GPG fingerprint: 61F0 8272 6882 BCA6 3A35  88F6 B630 4B72 DEEB D08B
