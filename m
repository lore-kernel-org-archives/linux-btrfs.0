Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp205.alice.it ([82.57.200.101]:40913 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab2I0VCT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Sep 2012 17:02:19 -0400
Message-ID: <5064BEEB.1090707@libero.it>
Date: Thu, 27 Sep 2012 23:02:35 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
CC: =?UTF-8?B?U8OpYmFzdGllbiBNYXVyeQ==?= <sebastien.maury@inserm.fr>,
        linux-btrfs@vger.kernel.org, Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [RFC] btrfs fi df output [Was Re: BTRF - Storage Usage]
References: <20120927124427.6014ddq7wg88cc0o@imp.inserm.fr> <5064B96B.7060502@libero.it>
In-Reply-To: <5064B96B.7060502@libero.it>
Content-Type: text/plain; charset=UTF-8; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry for the space error:
Below a more correct example

$ btrfs filesystem disk-free /
Summary:
    Total:             	        135.00GB
    Allocated:             	 10.51GB
    Unallocated:            	124.49GB
    Free_(Estimated)              86.56GB
    Average_disk_efficiency:         62 %

Details:
    Chunk-type    Mode       Allocated        Used        Free
    ----------    ----       ---------    --------   ---------
    Data          Single        4.01GB      2.16GB      1.87GB
    System        DUP          16.00MB      4.00KB      7.99MB
    System        Single        4.00MB        0.00      4.00MB
    Metadata      DUP           6.00GB    429.16MB      2.57GB
    Metadata      Single        8.00MB        0.00      8.00MB

