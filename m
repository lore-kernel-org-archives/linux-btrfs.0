Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rev-242.21.220.91.inhetmidden.nl ([91.220.21.242]:42721 "EHLO
	champignon.inhetmidden.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaBYJqu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 04:46:50 -0500
Received: from rev-9.21.220.91.quarantainenet.nl ([91.220.21.9] helo=[10.100.3.13])
	by champignon.inhetmidden.nl with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <justin@internetionals.nl>)
	id 1WIE7W-0003LW-VN
	for linux-btrfs@vger.kernel.org; Tue, 25 Feb 2014 10:16:17 +0100
Message-ID: <530C5F65.6020607@internetionals.nl>
Date: Tue, 25 Feb 2014 10:16:21 +0100
From: Justin Ossevoort <justin@internetionals.nl>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: VM nocow, should VM software set +C by default?
References: <A2EE3F12-97D9-46CD-8360-ACCFF71F149B@colorremedies.com>
In-Reply-To: <A2EE3F12-97D9-46CD-8360-ACCFF71F149B@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I think in principle: No.

It is something that should be documented as advise in the VM software 
documentation. But things like storage management is the domain of the 
distribution or systems administrator.

There might be a situation where the VM software can directly use a 
btrfs filesystem for it's storage engines where it could be sensible to 
add such a thing, but in that case it's already directly managing it's 
subvolumes and can turn nodatacow on/off when appropriate.
In that case it would probably also be using some of it's higher level 
functions for snapshotting, acls and possibly metadata (and not as a 
dumb container for disk images).

So if the VM software would be controlling the filesystem directly, than 
it could be useful but would probably be better achieved using different 
options.
If the VM software is merely using it to store image files, than it 
would be up to the distribution/systems administrator to set a '+C' on 
the directory where the images will be stored (that flag were being 
inherited iirc).
A distribution could easily try marking the default images directory 
with '+C' on installation for "Joe Average" user (when he decides to do 
things differently, than that's his conscious choice). But it could also 
decide that a better default would be to use a entirely different 
subvolume for VM images, with another raid level and no compression but 
with CoW enabled by default (and thus relying on autodefrag to work).

It should simply be a matter of: Who manages the storage decides how it 
should be configured and whether not to do CoW is an aspect of 
configuration.

Regards,

	justin....

On 21-02-14 17:55, Chris Murphy wrote:
> Use case is a user who doesn't know that today xattr +C ought to be set on vm images when on Btrfs. They use e.g. Gnome Boxes, or Virtual Machine Manager (virt-manager) to configure pools, images, and VMs.
>
> If libvirt were to set +C on any containing directory configured as a pool, then any copied as well as newly created images would inherit +C. So is this the long term recommended practice, and should various VM projects be asked to build this functionality? Or will there be optimizations, such as autodefrag, that will obviate the need for +C on such VM images in the somewhat near future?
>
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
