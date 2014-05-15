Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44103 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbaEOFGv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 May 2014 01:06:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WknsX-0003ui-Pn
	for linux-btrfs@vger.kernel.org; Thu, 15 May 2014 07:06:49 +0200
Received: from 177.18.142.132 ([177.18.142.132])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 15 May 2014 07:06:49 +0200
Received: from bcdonadio by 177.18.142.132 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 15 May 2014 07:06:49 +0200
To: linux-btrfs@vger.kernel.org
From: Bernardo Donadio <bcdonadio@gmail.com>
Subject: Re: lsetxattr error when doing send/receive
Date: Thu, 15 May 2014 02:06:35 -0300
Message-ID: <ll1i0s$1l7$1@ger.gmane.org>
References: <lkuapc$si7$1@ger.gmane.org> <20140514015746.GA8032@davidb.org> <5B4A1BF5-7178-448B-8989-50B793C0912D@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <5B4A1BF5-7178-448B-8989-50B793C0912D@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/14/2014 03:52 AM, Chris Murphy wrote:
> Reverse that. If selinux is disabled, labels can't be set. If not enforcing, you won't get AVC denials for the vast majority of events, but labels can be set and e.g. restorecon will still work.

Indeed, enabling SELinux into permissive mode solved the problem.

Thanks.
-- 
Bernardo Donadio

