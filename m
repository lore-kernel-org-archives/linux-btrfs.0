Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32809 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752298AbdHBSpG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Aug 2017 14:45:06 -0400
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Brendan Hide <brendan@swiftspirit.co.za>, <linux-btrfs@vger.kernel.org>
References: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
From: Chris Mason <clm@fb.com>
Message-ID: <05695141-f23a-e0f7-dba5-d23f65681283@fb.com>
Date: Wed, 2 Aug 2017 14:44:49 -0400
MIME-Version: 1.0
In-Reply-To: <84806456-eed9-00b9-b3f6-99e46cefba33@swiftspirit.co.za>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/02/2017 04:38 AM, Brendan Hide wrote:
> The title seems alarmist to me - and I suspect it is going to be 
> misconstrued. :-/

Supporting any filesystem is a huge amount of work.  I don't have a 
problem with Redhat or any distro picking and choosing the projects they 
want to support.

At least inside of FB, our own internal btrfs usage is continuing to 
grow.  Btrfs is becoming a big part of how we ship containers and other 
workloads where snapshots improve performance.

We also heavily use XFS, so I'm happy to see RH's long standing 
investment there continue.

-chris
