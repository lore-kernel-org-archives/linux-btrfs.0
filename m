Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28320 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbbHSDSv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 23:18:51 -0400
Message-ID: <55D3F4FA.6080309@oracle.com>
Date: Wed, 19 Aug 2015 11:16:10 +0800
From: anand jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, eguan@redhat.com,
        fdmanana@gmail.com
Subject: Re: [PATCH v6 1/3] xfstests: btrfs: add functions to create dm-error
 device
References: <1439549224-29784-1-git-send-email-anand.jain@oracle.com> <1439566305-12460-1-git-send-email-anand.jain@oracle.com> <1439566305-12460-2-git-send-email-anand.jain@oracle.com> <20150816235218.GD20596@dastard> <55D2B40E.5040801@oracle.com> <20150818221157.GE3902@dastard>
In-Reply-To: <20150818221157.GE3902@dastard>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> Ok, SCRATCH_OPTIONS might not be the best idea here, so feel free to
> drop it.

  I have dropped $SCRATCH_OPTIONS. (waiting to submit v8). Thanks.

> However, you've still missed the primary reason I suggested
> _scratch_mount_options in the first place:

  I am shocked. What was missed ?

Cheers, Anand

