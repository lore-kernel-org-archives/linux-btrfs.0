Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2350 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbaG3UrS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 16:47:18 -0400
Message-ID: <53D959D0.1020303@fb.com>
Date: Wed, 30 Jul 2014 16:47:12 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Nicholas Krause <xerofoify@gmail.com>, <clm@fb.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove certain calls for releasing page cache
References: <1406752954-26158-1-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1406752954-26158-1-git-send-email-xerofoify@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/30/2014 04:42 PM, Nicholas Krause wrote:
> This patch removes the lines for releasing the page cache in certain
> files as this may aid in perfomance with writes in the compression
> rountines of btrfs. Please note that this patch has not been tested
> on my own hardware due to no compression based btrfs volumes of my
> own.
>

http://37.media.tumblr.com/tumblr_m44v95k9Y11qjhgo6o1_250.gif

Josef
