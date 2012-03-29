From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: Create subvolume from a directory?
Date: Thu, 29 Mar 2012 09:24:44 +0800
Message-ID: <4F73B9DC.3040402@cn.fujitsu.com>
References: <loom.20120327T190041-268@post.gmane.org> <20120327222422.GA32675@suse.com> <4F727504.3070105@cn.fujitsu.com> <4F734250.5030009@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Matthias G. Eckermann" <mge@suse.com>, Alex <alex@bpmit.com>,
	linux-btrfs@vger.kernel.org
To: kreijack@inwind.it
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F734250.5030009@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/29/2012 12:54 AM, Goffredo Baroncelli wrote:
>>
> 
> Could you elaborate which would be the issue ?
> "cp --reflink"-ing a file is not different than snapshotting a file. In
> any case I could mount a snapshot and not the source subvolume.
> 
> 
> 

We already have a debate about this "cross-link device":
http://comments.gmane.org/gmane.comp.file-systems.btrfs/9864

"cp --reflink" will use clone feature, which can share data among files, but metadata is preserved individually.

My case is that I can mount both a subvolume and a snapshot via "-o subvol=xxx" or "-o subvolid=xxx".

thanks,
liubo
