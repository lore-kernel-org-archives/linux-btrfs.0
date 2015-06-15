Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:35309 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861AbbFOJds (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 05:33:48 -0400
Received: by wiga1 with SMTP id a1so71063966wig.0
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2015 02:33:47 -0700 (PDT)
Received: from Ingvars-MacBook-Pro.local ([95.90.247.242])
        by mx.google.com with ESMTPSA id fm8sm14931865wib.9.2015.06.15.02.33.45
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jun 2015 02:33:46 -0700 (PDT)
From: Ingvar Bogdahn <ingvar.bogdahn@googlemail.com>
Message-ID: <557E9C2B.9030404@gmail.com>
Date: Mon, 15 Jun 2015 11:34:35 +0200
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: CoW with webserver databases: innodb_file_per_table and dedicated
 tables for blobs?
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello there,

I'm planing to use btrfs for a medium-sized webserver. It is commonly 
recommended to set nodatacow for database files to avoid performance 
degradation. However, apparently nodatacow disables some of my main 
motivations of using btrfs : checksumming and (probably) incremental 
backups with send/receive (please correct me if I'm wrong on this). 
Also, the databases are among the most important data on my webserver, 
so it is particularly there that I would like those feature working.

My question is, are there strategies to avoid nodatacow of databases 
that are suitable and safe in a production server?
I thought about the following:
- in mysql/mariadb: setting "innodb_file_per_table" should avoid having 
few very big database files.
- in mysql/mariadb: adapting database schema to store blobs into 
dedicated tables.
- btrfs: set autodefrag or some cron job to regularly defrag only 
database fails to avoid performance degradation due to fragmentation
- turn on compression on either btrfs or mariadb

Is this likely to give me ok-ish performance? What other possibilities 
are there?

Thanks for your recommendations.

ingvar
