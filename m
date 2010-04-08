From: Avi Kivity <avi@redhat.com>
Subject: Re: Poor performance with qemu
Date: Thu, 08 Apr 2010 18:36:15 +0300
Message-ID: <4BBDF7EF.4010100@redhat.com>
References: <201003281718.03699.diegocg@gmail.com> <20100330125623.GB13190@think> <4BBDEF09.70306@redhat.com> <20100408152615.GI1400@think> <4BBDF636.5010002@redhat.com> <20100408153456.GA26113@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>,
	Diego Calleja <diegocg@gmail.com>, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100408153456.GA26113@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/08/2010 06:34 PM, Christoph Hellwig wrote:
> On Thu, Apr 08, 2010 at 06:28:54PM +0300, Avi Kivity wrote:
>    
>> When it updates qcow2 metadata or when the guest issues a barrier.  It's
>> relatively new.  I have a patch that introduces cache=volatile somewhere.
>>      
> qcow2 does not issues any fsyncs by itself, it only passes throught the
> guests ones.  The only other placess issueing fsyncs is commit a COW
> image back to the base image, and on migreation.
>    

Shouldn't it do that then?  What's the point of fsyncing guest data if 
qcow2 metadata is volatile?

-- 
error compiling committee.c: too many arguments to function

