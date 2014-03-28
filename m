Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46644 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaC1Xr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Mar 2014 19:47:58 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: RHEL/CentOS or Debian for stable deployment
From: Avi Miller <avi.miller@oracle.com>
In-Reply-To: <533607E1.8060202@benjamindsmith.com>
Date: Sat, 29 Mar 2014 10:47:53 +1100
Cc: =?windows-1252?Q?Johan_Kr=F6ckel?= <johan.kroeckel@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <9E7F7A76-9D7D-4410-AD88-2BD95C56A80D@oracle.com>
References: <CABgvyo_b19P2QPzszv6Vxc2iHOceP-ndCp1oUzO6Hc=Z4CiJ=A@mail.gmail.com> <CF9CC748-3700-4D4F-AB96-03F27EA9C32B@oracle.com> <533607E1.8060202@benjamindsmith.com>
To: Lists <lists@benjamindsmith.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 29 Mar 2014, at 10:38 am, Lists <lists@benjamindsmith.com> wrote:

> On 03/28/2014 02:42 PM, Avi Miller wrote:
>> Have you considered Oracle Linux? We are continually backporting btrfs fixes and enhancements to our Unbreakable Enterprise Kernel releases. On Oracle Linux 6, you would run the UEK Release 3, which is based on 3.8 mainline with upstream fixes. We also provide all security and bug fix errata for free viahttp://public-yum.oracle.com, so you don’t need to buy support to run Oracle Linux at keep up-to-date.
> 
> Can't remember asking if btrfs is supported on 32 bit kernels?

We support btrfs on our 32-bit UEK Release 2 (labelled 2.6.39 but it’s actually 3.0 under the hood. Yay userspace issues). However, our latest UEK Release 3 (3.8 both labelled and under-the-hood) is only built for 64-bit and is highly recommended for production btrfs usage. We are no longer back porting mainline fixes into UEK Release 2 because the code has just moved on too far for it to be feasible.

So, while there is a 32-bit kernel with btrfs support, our recommendation is to use the 64-bit kernel on x86_64 hardware for the best experience.

--
Oracle <http://www.oracle.com>
Avi Miller | Product Management Director | +61 (3) 8616 3496
Oracle Linux and Virtualization
417 St Kilda Road, Melbourne, Victoria 3004 Australia

