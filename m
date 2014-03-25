Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981AbaCYU5Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Mar 2014 16:57:24 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s2PKvNkZ007575
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 16:57:24 -0400
Received: from [10.3.113.2] ([10.3.113.2])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s2PKvNMr013220
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Mar 2014 16:57:23 -0400
Message-ID: <5331EDB3.3080903@redhat.com>
Date: Tue, 25 Mar 2014 13:57:23 -0700
From: Andy Grover <agrover@redhat.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: btrfs-progs relicensing update
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

In the process to relicense btrfs-progs to LGPLv2.1[1], we have 40 of 
114 approvals so far. I have sent mass-emails to everyone with more than 
1 commit, and am now sending individual emails down the list to people I 
haven't heard from.

(I'm waiting to tackle the single-commit people until we get all the 
more major contributors.)

Here's progress so far:

https://docs.google.com/spreadsheet/ccc?key=0AuE18RMM7JeKdFF4OVdsYU9GVmVEOGNKajdPYThHSWc&usp=sharing

If you are a contributor and haven't yet given your ok, please feel free 
to reply to me off-list with this text:

-I grant permission to re-license my contributed code to btrfs-progs
under the GNU LGPLv2.1 license.-

and I'll be sure to count you :-)

Thanks -- Regards -- Andy

[1] this is to allow btrfs-progs to be used as a library without 
licensing considerations.
