From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH 2/3] 265: Functional test case for the btrfs de-fragmentation
Date: Thu, 20 Oct 2011 23:32:24 +0800
Message-ID: <4EA03F08.4050400@oracle.com>
References: <20111013005652.GM3159@dastard> <1318919336-32206-1-git-send-email-Anand.Jain@oracle.com> <1318919336-32206-3-git-send-email-Anand.Jain@oracle.com> <20111019094356.GC3083@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com, david@fromorbit.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20111019094356.GC3083@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>



On 19/10/2011 17:43, Christoph Hellwig wrote:
> On Tue, Oct 18, 2011 at 02:28:55PM +0800, Anand Jain wrote:
>> To verify the btrfs de-fragmentation does not fail.
> 
> Any reason you can't simply fold btrfs defragmentation testing into
> the existing common defragmentation test (218)?

  oh! 218 ! let me defer defrag for now. will get the other test-cases
  going. thanks
anand
