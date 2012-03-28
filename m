From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: Create subvolume from a directory?
Date: Wed, 28 Mar 2012 10:18:44 +0800
Message-ID: <4F727504.3070105@cn.fujitsu.com>
References: <loom.20120327T190041-268@post.gmane.org> <20120327222422.GA32675@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Alex <alex@bpmit.com>, linux-btrfs@vger.kernel.org
To: "Matthias G. Eckermann" <mge@suse.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120327222422.GA32675@suse.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/28/2012 06:24 AM, Matthias G. Eckermann wrote:
> Hello Alex and all,
> 
> On 2012-03-27 T 17:19 +0000 Alex wrote:
> 
>> Just a quick question but can't find an obvious answer.
>>
>> Can I create/convert a existing (btrfs) directory into a
>> subvolume?
>>
>> It would be very helpful when transferring 'partitions'
>> into btrfs.  I found a similar question way back in
>> google, but that site is down now generally.
> 
> As far as I am aware, this is not possible directly. My
> approach to this would be using copy with reflinks:
> 
> ------------------------------< snip >------------------------------
> 
> ## migrate /var/lib/lxc/installserver 
> ## from directory to btrfs subvolume
> 
> # du -ks /var/lib/lxc/installserver
> 500332  /var/lib/lxc/installserver
> 
> # mv /var/lib/lxc/installserver /var/lib/lxc/installserver_tmp
> 
> # btrfs subvol create /var/lib/lxc/installserver
> Create subvolume '/var/lib/lxc/installserver'
> 
> # time cp -a --reflink /var/lib/lxc/installserver_tmp/rootfs /var/lib/lxc/installserver
> 

This is too much weird.

AFAIK, clone between different subvolumes should be forbidden.
So this would get a "Invalid cross-device link", because an individual subvolume can be mounted directly.

thanks,
liubo

> real    0m1.367s
> user    0m0.148s
> sys     0m1.108s
> 
> ## Now remove /var/lib/lxc/installserver_tmp (or not)
> 
> ------------------------------< snap >------------------------------
> 
> Just to compare this with a "mv":
> 
> ------------------------------< snip >------------------------------
> 
> ## Go back to former state
> 
> # btrfs subvol delete /var/lib/lxc/installserver
> Delete subvolume '/var/lib/lxc/installserver'
> 
> # btrfs subvol create /var/lib/lxc/installserver
> Create subvolume '/var/lib/lxc/installserver'
> 
> # time mv /var/lib/lxc/installserver_tmp/rootfs /var/lib/lxc/installserver/
> 
> real    0m12.917s
> user    0m0.208s 
> sys     0m2.508s 
> 
> ------------------------------< snap >------------------------------
> 
> While the time measurement might be flawed due to the subvol
> actions inbetween, caching etc.: I tried several times, and
> "cp --reflinks" always is multiple times faster than "mv" in
> my environment.
> 
> Or did I misunderstand your question?
> 
> so long -
> 	MgE
> 

