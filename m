From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Poor performance with qemu
Date: Thu, 8 Apr 2010 11:34:56 -0400
Message-ID: <20100408153456.GA26113@infradead.org>
References: <201003281718.03699.diegocg@gmail.com> <20100330125623.GB13190@think> <4BBDEF09.70306@redhat.com> <20100408152615.GI1400@think> <4BBDF636.5010002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>,
	Diego Calleja <diegocg@gmail.com>, linux-btrfs@vger.kernel.org
To: Avi Kivity <avi@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BBDF636.5010002@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 08, 2010 at 06:28:54PM +0300, Avi Kivity wrote:
> When it updates qcow2 metadata or when the guest issues a barrier.  It's  
> relatively new.  I have a patch that introduces cache=volatile somewhere.

qcow2 does not issues any fsyncs by itself, it only passes throught the
guests ones.  The only other placess issueing fsyncs is commit a COW
image back to the base image, and on migreation.

