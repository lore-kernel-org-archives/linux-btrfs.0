Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:53937 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744Ab2HCE7U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Aug 2012 00:59:20 -0400
Message-ID: <501B5AA7.20808@jan-o-sch.net>
Date: Fri, 03 Aug 2012 06:59:19 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Liu Bo <liub.liubo@gmail.com>, Josef Bacik <jbacik@fusionio.com>
CC: Arne Jansen <sensille@gmx.net>, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: [PATCH v2] Btrfs: remove superblock writing after fatal error
References: <1343821552-28726-1-git-send-email-sbehrens@giantdisaster.de> <50191AD3.9080401@gmail.com> <50192A11.3060109@jan-o-sch.net> <50192FCE.30006@gmail.com> <50193DDA.20504@giantdisaster.de> <501A56E3.3080401@giantdisaster.de> <501A583D.8030600@gmail.com> <501A61ED.3000908@gmx.net> <501A65B9.5060004@gmail.com> <501A6731.4000405@gmx.net> <501A6B0D.6050303@gmail.com> <501A84CA.10604@gmx.net> <501A8E7A.6070601@jan-o-sch.net> <501B436F.1040105@gmail.com>
In-Reply-To: <501B436F.1040105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[added Josef]

Josef: Please queue this patch for rc2, we finally agreed.

On Fri, August 03, 2012 at 05:20 (+0200), Liu Bo wrote:
> On 08/02/2012 10:28 PM, Jan Schmidt wrote:
>> If such a situation doesn't exist, there's no need for this flag. The fact that
>> ext has such a flag doesn't convince me, probably because I know nothing about
>> ext. I can imagine that they can detect file system errors without the ability
>> to return to a potentially older consistent state.
>>
> 
> This error flag is also used to indicate filesystem's error state for
> transaction cleanup, so keeping it in memory is reasonable.

Granted :-)

-Jan
