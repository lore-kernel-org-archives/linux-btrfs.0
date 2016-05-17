Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751609AbcEQNcQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 09:32:16 -0400
Date: Tue, 17 May 2016 14:32:14 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, ptoscano@redhat.com
Subject: Re: RFE: 'btrfs' tools machine readable output
Message-ID: <20160517133214.GT1683@redhat.com>
References: <20160516121456.GA16970@redhat.com>
 <20160517093307.GG511@twin.jikos.cz>
 <c7d51f53-d3f9-d95f-cb4d-c320ced4ca9b@gmail.com>
 <20160517122326.GJ511@twin.jikos.cz>
 <b9136e93-2099-245e-46a0-941d72279e1f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b9136e93-2099-245e-46a0-941d72279e1f@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As I said I don't have any particular favourite format.  However I'll
just point you to the code that qemu uses (basically open-coding) to
write json:

http://git.qemu.org/?p=qemu.git;a=blob;f=qobject/qjson.c;h=ef160d2119eb18aa917b71b40e37d54880b1ac7f;hb=HEAD#l83

Hopefully this is useful as a data point.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
Fedora Windows cross-compiler. Compile Windows programs, test, and
build Windows installers. Over 100 libraries supported.
http://fedoraproject.org/wiki/MinGW
