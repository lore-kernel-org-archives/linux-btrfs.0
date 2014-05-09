Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24400 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756779AbaEIRXk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 9 May 2014 13:23:40 -0400
Message-ID: <536D0F10.3040305@fb.com>
Date: Fri, 9 May 2014 13:23:28 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs snapshot sizes
References: <20140507111949.GT10159@merlins.org>
In-Reply-To: <20140507111949.GT10159@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/07/2014 07:19 AM, Marc MERLIN wrote:
> So have others found a good way to have an idea about how much space is
> taken by each snapshot?
>
> I've tried quota trees, but I'm not sure how to read the output, or if it's
> correct (including the negative numbers some have mentioned). Are there
> other options?
>
> I think the main problem is that the shared data field is not working,
> making it harder to know which blocks are only used in a given snapshot.
>
>
> subvol                                          group         total    unshared
> -------------------------------------------------------------------------------
> backup/debian32                                 0/262       403.84G      -5.46G
> backup/debian32_daily_20140504_00:03:01         0/3660      446.45G       0.00G
> backup/debian32_daily_20140505_00:03:01         0/3687      431.11G       0.00G
> backup/debian32_daily_20140506_00:03:00         0/3705      420.83G       0.00G
> backup/debian32_daily_20140507_00:03:01         0/3724      411.87G       0.00G
> backup/debian32_weekly_20140504_00:04:01        0/3675      446.45G       0.00G
>
> backup/debian64                                 0/263       855.97G      -1.50G
> backup/debian64_daily_20140504_00:03:01         0/3662      860.19G       0.00G
> backup/debian64_daily_20140505_00:03:01         0/3690      859.32G       0.00G
> backup/debian64_daily_20140506_00:03:00         0/3707      858.15G       0.00G
> backup/debian64_daily_20140507_00:03:01         0/3726      857.47G       0.00G
> backup/debian64_weekly_20140504_00:04:01        0/3676      860.19G       0.00G
>
> backup/ubuntu                                   0/264       360.28G       0.00G
> backup/ubuntu_daily_20140504_00:03:01           0/3664      364.53G       0.00G
> backup/ubuntu_daily_20140505_00:03:01           0/3692      362.44G       0.00G
> backup/ubuntu_daily_20140506_00:03:00           0/3709      360.91G       0.00G
> backup/ubuntu_daily_20140507_00:03:01           0/3727      360.33G       0.00G
> backup/ubuntu_weekly_20140504_00:04:01          0/3677      364.53G       0.00G
>
>

Quota's wont work quite right unless you have my most recent patch, give 
that a whirl and you should be good to go.  Thanks,

Josef

