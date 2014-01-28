Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36212 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbaA1JTn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Jan 2014 04:19:43 -0500
Message-ID: <52E77879.1080000@oracle.com>
Date: Tue, 28 Jan 2014 17:29:29 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Gerhard Heift <gerhard@heift.name>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFCv2] new ioctl TREE_SEARCH_V2
References: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
In-Reply-To: <1390829312-814-1-git-send-email-Gerhard@Heift.Name>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



  You may have covered this but its not explicit.
  Could you write few lines on whats wrong with the current
  TREE SEARCH and how V2 is helping.

Thanks, Anand



On 01/27/2014 09:28 PM, Gerhard Heift wrote:
> This patch series adds a new ioctl TREE_SEARCH_V2 with which we could store the
> results in a varying buffer. Now even items larger than 3992 bytes or a large
> amount of items can be returned.
>
> I have a few questions:
>    Which value should I assign to TREE_SEARCH_V2?
>    Should we limit the buffer size?
>    What about documentation?
>
> Changelog
>
> RFCv2
>    * fixed a build bug caused by using a wrong patch
>    * added a patch to expand buffer lifetime
>
> Gerhard
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
