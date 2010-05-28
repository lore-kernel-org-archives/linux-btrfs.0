From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH 6/6] Btrfs: do aio_write instead of write
Date: Fri, 28 May 2010 09:42:34 +0800
Message-ID: <4BFF1F8A.6050506@cn.fujitsu.com>
References: <1274461422-18433-1-git-send-email-josef@redhat.com> <1274461422-18433-6-git-send-email-josef@redhat.com> <4BFDE1CE.4030100@cn.fujitsu.com> <20100527125952.GQ3108@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100527125952.GQ3108@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/27/2010 08:59 PM, Chris Mason wrote:
> Thanks for sending along this test program and bug report.  We've fixed
> a few bugs in the O_DIRECT patches, and this is working now.
>
> The merged result is in the for-linus branch of the btrfs unstable tree.
>
> -chris
>   

Oh, Thanks a lot. I've see your great effort.

-liubo
