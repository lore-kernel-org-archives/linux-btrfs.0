Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:52575 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725805AbeIGJTR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 7 Sep 2018 05:19:17 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id BA5CD354
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 00:40:11 -0400 (EDT)
Received: from [10.0.0.6] (cpe00248caf16e4-cmbc4dfbde0a70.cpe.net.cable.rogers.com [99.240.134.203])
        by mail.messagingengine.com (Postfix) with ESMTPA id C642B10294
        for <linux-btrfs@vger.kernel.org>; Fri,  7 Sep 2018 00:40:10 -0400 (EDT)
Subject: Re: Re-mounting removable btrfs on different device
To: linux-btrfs@vger.kernel.org
References: <990de394-15d2-55f3-c5ae-bef2de734978@georgianit.com>
 <pan$d71b0$8d25ba8$5bb37179$bc1641a5@cox.net>
From: Remi Gauvin <remi@georgianit.com>
Message-ID: <e3a300af-51ef-0e2b-ce02-8fe0a71eb43d@georgianit.com>
Date: Fri, 7 Sep 2018 00:40:10 -0400
MIME-Version: 1.0
In-Reply-To: <pan$d71b0$8d25ba8$5bb37179$bc1641a5@cox.net>
Content-Type: multipart/mixed;
 boundary="------------554AC617F139F43F99097C4F"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------554AC617F139F43F99097C4F
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 2018-09-06 11:32 PM, Duncan wrote:

> Without the mentioned patches, the only way (other than reboot) is to 
> remove and reinsert the btrfs kernel module (assuming it's a module, not 
> built-in), thus forcing it to forget state.
> 
> Of course if other critical mounted filesystems (such as root) are btrfs, 
> or if btrfs is a kernel-built-in not a module and thus can't be removed, 
> the above doesn't work and a reboot is necessary.  Thus the need for 
> those patches you mentioned.
> 

Good to know, thanks.

--------------554AC617F139F43F99097C4F
Content-Type: text/x-vcard; charset=utf-8;
 name="remi.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="remi.vcf"

begin:vcard
fn:Remi Gauvin
n:Gauvin;Remi
org:Georgian Infotech
adr:;;3-51 Sykes St. N.;Meaford;ON;N4L 1X3;Canada
email;internet:remi@georgianit.com
tel;work:226-256-1545
version:2.1
end:vcard


--------------554AC617F139F43F99097C4F--
