Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbaAOSTB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 13:19:01 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0FIJ05s024610
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2014 13:19:00 -0500
Received: from agrover.csb ([10.3.113.13])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id s0FIJ0LZ001428
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2014 13:19:00 -0500
Message-ID: <52D6D113.10308@redhat.com>
Date: Wed, 15 Jan 2014 10:18:59 -0800
From: Andy Grover <agrover@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Btrfs-progs Relicensing effort has begun
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

We want to relicense btrfs-progs, using the LGPLv2.1 instead of GPLv2.

We can then build btrfs-progs code as a shared library, libbtrfs, and 
this library can be used by other code -- GPLv3+, BSD/Apache, and 
non-free, without causing the GPLv2 to apply to the other code.

This will allow btrfs support to be more tightly integrated into other 
management tools.

Chris Mason, as well as Oracle, have approved this change and are 
on-board, but we also need *all* contributors to agree.

I will be emailing all contributors (as shown by git) over the next few 
weeks. Progress will be shown here:

https://docs.google.com/spreadsheet/ccc?key=0AuE18RMM7JeKdFF4OVdsYU9GVmVEOGNKajdPYThHSWc&usp=sharing

Instead of waiting for the email, you can also email me now 
(agrover@redhat.com) with the below phrase, or something similar:

-I grant permission to re-license my contributed code to btrfs-progs 
under the GNU LGPLv2.1 license.-

or with any questions.

Thanks! -- Regards -- Andy
