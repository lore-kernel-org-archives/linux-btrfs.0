Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36403 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbaCTSOe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Mar 2014 14:14:34 -0400
Received: by mail-ig0-f173.google.com with SMTP id t19so15670870igi.0
        for <linux-btrfs@vger.kernel.org>; Thu, 20 Mar 2014 11:14:34 -0700 (PDT)
Received: from [10.80.50.89] (CPEbc14012ad2f3-CMbc14012ad2f0.cpe.net.cable.rogers.com. [99.238.119.135])
        by mx.google.com with ESMTPSA id u1sm6082519igm.8.2014.03.20.11.14.33
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 20 Mar 2014 11:14:33 -0700 (PDT)
Message-ID: <532B3009.6040608@gmail.com>
Date: Thu, 20 Mar 2014 14:14:33 -0400
From: Adam Khan <adam.s.khan@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Please advise on repair action
References: <532931D9.60809@gmail.com>
In-Reply-To: <532931D9.60809@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Does anyone know if my issue is btrfs related or if it is more likely hardware related:
http://www.spinics.net/lists/linux-btrfs/msg30999.html

My kernel is from Debian Jessie:
3.13-1-amd64 #1 SMP Debian 3.13.5-1 (2014-03-04) x86_64 GNU/Linux

Thanks for any insight

On 19/03/14 01:57 AM, Adam Khan wrote:
> Hello,
> 
> I have a simple btrfs located on a dm-crypt volume. I'm getting a general protection fault when I 
> attempt to access a specific directory in Thunar file manager and in a Python program.
> 
> The trace is attached for Thunar.
> 
> btrfsck returns this:
> 
> Checking filesystem on /dev/mapper/xyz_crypt
> UUID: ...
> found 88316880601 bytes used err is 1
> total csum bytes: 180423792
> total tree bytes: 291459072
> total fs tree bytes: 50192384
> total extent tree bytes: 12898304
> btree space waste bytes: 55087032
> file data blocks allocated: 352826490880
>  referenced 184697802752
> Btrfs v3.12
> 
> How should I proceed to repair this fs?
> 
> Best regards,
> 
> Adam
> 
