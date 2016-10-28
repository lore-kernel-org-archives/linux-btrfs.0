Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39418 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753308AbcJ1MX0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Oct 2016 08:23:26 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A1E7C31B327
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Oct 2016 12:23:25 +0000 (UTC)
Received: from [IPv6:::1] (ovpn03.gateway.prod.ext.phx2.redhat.com [10.5.9.3])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id u9SCNOcV014980
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Oct 2016 08:23:25 -0400
Subject: Re: [PATCH] btrfs-progs: fix build for programs including ioctl.h
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <343f2d64-948b-9653-18eb-76ae2e852b88@redhat.com>
 <ae29e753-b1fc-f433-d498-bc50209bfa8d@redhat.com>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <b82b9a18-eb7f-24d9-828a-1959e2d5504c@redhat.com>
Date: Fri, 28 Oct 2016 07:23:24 -0500
MIME-Version: 1.0
In-Reply-To: <ae29e753-b1fc-f433-d498-bc50209bfa8d@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/27/16 9:54 PM, Eric Sandeen wrote:
> On 10/13/16 12:36 PM, Eric Sandeen wrote:
>> This was reported when docker failed to build against
>> btrfs-progs v4.8.1.
>>
>> It includes ioctl.h which now calls BUILD_ASSERT(), which
>> is defined in kerncompat.h, which was not included in the
>> ioctl.h header file.
> 
> Ping?

Oh sorry I see it's in, I had searched by author and missed it.

Thanks,
-Eric

