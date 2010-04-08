From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Poor performance with qemu
Date: Thu, 8 Apr 2010 11:39:42 -0400
Message-ID: <20100408153942.GA30547@infradead.org>
References: <201003281718.03699.diegocg@gmail.com> <20100330125623.GB13190@think> <4BBDEF09.70306@redhat.com> <20100408152615.GI1400@think> <4BBDF636.5010002@redhat.com> <20100408153456.GA26113@infradead.org> <4BBDF7EF.4010100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Chris Mason <chris.mason@oracle.com>,
	Diego Calleja <diegocg@gmail.com>, linux-btrfs@vger.kernel.org
To: Avi Kivity <avi@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4BBDF7EF.4010100@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 08, 2010 at 06:36:15PM +0300, Avi Kivity wrote:
> Shouldn't it do that then?  What's the point of fsyncing guest data if  
> qcow2 metadata is volatile?

Not my territory - but in the end getting qcow2 as-is solid in face
of crashes will be an uphill battel - I'd rather recommend not using it.

