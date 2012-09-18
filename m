Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:33687 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab2IRVqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 17:46:43 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.0 \(1486\))
Subject: Re: Experiences: Why BTRFS had to yield for ZFS
From: Avi Miller <avi.miller@oracle.com>
In-Reply-To: <5058A5C8.8080107@affinityvision.com.au>
Date: Wed, 19 Sep 2012 07:46:26 +1000
Cc: Casper Bnag <casper.bang@gmail.com>, linux-btrfs@vger.kernel.org
Message-Id: <1D7A485E-4471-45AA-9B57-A4A1173B399C@oracle.com>
References: <CALdWcbiW2ctG50ZCSzpTHA8t1CAhwTj66=GCoLcAFjGsjFBQJw@mail.gmail.com> <20120917091543.GC29881@charite.de> <loom.20120917T113953-444@post.gmane.org> <55422103-3EA7-4DE9-9C47-351CBD006871@oracle.com> <5058A5C8.8080107@affinityvision.com.au>
To: Andrew McGlashan <andrew.mcglashan@affinityvision.com.au>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 19/09/2012, at 2:48 AM, Andrew McGlashan <andrew.mcglashan@affinityvision.com.au> wrote:

> On 17/09/2012 8:05 PM, Avi Miller wrote:
>> Oracle Database is not certified to run on either btrfs or ZFS on Linux, so if certification is an issue, you can't use either filesystem. Out of interest, have you done a performance benchmark with ASM using ASMlib on the same platform? 
> 
> I thought that Oracle considered BTRFS to be production ready.  It
> surprises me that running an Oracle database on BTRFS is not a supported
> configuration.


The Oracle Linux team considers btrfs production-ready and we support it for production purposes for customers. However, we have nothing to do with Database and their certification process, and the Database (and other) product teams have not certified it for use with their products yet. This is also why product certification lags: we have nothing to do with individual product certification processes on various operating systems/platforms. 

So, while I'm aware that the database team is planning to certify btrfs "at some point", I suspect with Oracle OpenWorld coming up in a few weeks time, they have other things on their plate right now. :)

--
Oracle <http://www.oracle.com>
Avi Miller | Principal Program Manager | +61 (412) 229 687
Oracle Linux and Virtualization
417 St Kilda Road, Melbourne, Victoria 3004 Australia






