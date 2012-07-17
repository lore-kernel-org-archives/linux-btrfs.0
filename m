Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp206.alice.it ([82.57.200.102]:50035 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606Ab2GQRRs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jul 2012 13:17:48 -0400
Message-ID: <50059E37.1020703@inwind.it>
Date: Tue, 17 Jul 2012 19:17:43 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org,
        harald@redhat.com
Subject: Re: [PATCH] Btrfs: add DEVICE_READY ioctl
References: <1340309431-9972-1-git-send-email-jbacik@fusionio.com> <1340309431-9972-2-git-send-email-jbacik@fusionio.com> <4FE4B5A4.90603@libero.it> <20120717115334.GA11226@twin.jikos.cz>
In-Reply-To: <20120717115334.GA11226@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/17/2012 01:53 PM, David Sterba wrote:
> On Fri, Jun 22, 2012 at 08:12:52PM +0200, Goffredo Baroncelli wrote:
>> On 06/21/2012 10:10 PM, Josef Bacik wrote:
>>> This will be used in conjunction with btrfs device ready <dev>.  This is
[....]
> 
>> Finally I am starting to think that we should definitely switch to a
>> /sys/btrfs style of interface
> 
> I'm all for a sysfs interface, having an ioctl way of retrieving
> information is good, but not practical for use from scripting languages,
> namely for writing tests.

Moreover a sysfs interface is more extensible for further enanchement

> 
> There are some guys working on the sysfs patches, I did preliminary
> reviews. The first step is to bring back the core sysfs support (mostly
> done iirc) and then exporting various information.
> I'll check what's the status.

Great, are there public patches, I am interested in contributing

> 
>> think something like:
>>
>> /sys/btrfs/<fs-uuid>/<dev-uuid>/present
>>                                size
>>                                space-occuped
>>                                number-of-error
>>                                [...]
>>
>> /sys/btrfs/<fs-uuid>/<subvolume-id>/read-only
>>                                     compressed
>>                                     raid-mode
>>                                     path
>>                                     [...]
>>
>> /sys/btrfs/<fs-uuid>/label
>>                      mounted
>>                      read-only
>>                      compressed
>>                      raid-mode
>>                      [...]
> 
> That's a good start for a discussion.
> 
> 
> david
> .
> 

