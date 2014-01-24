Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:45311 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaAXS4B (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 13:56:01 -0500
Received: by mail-ea0-f172.google.com with SMTP id g15so1175897eak.17
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jan 2014 10:56:00 -0800 (PST)
Received: from [192.168.7.7] (a207.net131.okay.pl. [85.28.131.207])
        by mx.google.com with ESMTPSA id g1sm6670429eet.6.2014.01.24.10.55.58
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 24 Jan 2014 10:55:59 -0800 (PST)
Message-ID: <52E2B73E.1050903@gmail.com>
Date: Fri, 24 Jan 2014 19:55:58 +0100
From: KC <conrad.francois.artus@googlemail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Options for SSD - autodefrag etc?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 >>> From: Duncan <1i5t5.duncan <at> cox.net>
 >>>  Subject: Re: Options for SSD - autodefrag etc?
 >>>  Newsgroups: gmane.comp.file-systems.btrfs
 >>>  Date: 2014-01-24 06:54:31 GMT (11 hours and 44 minutes ago)
 >>> KC posted on Thu, 23 Jan 2014 23:23:35 +0100 as excerpted:


Duncan, thank you for this outstanding explanation. It was very 
informative and helpful.
I only have one follow-up question.

I followed your advice on NOCOW for virtualbox images and torrents like so:
chattr -v /home/juha/VirtualBox\ VMs/
chattr -RC /home/juha/Downloads/torrent/#unfinished

As you can see, i used the recursive flag. However, I do not know 
whether this will automatically apply to files that will be created in 
the future in subfolders that do not yet exist.

Also, how can I confirm whether a file/folder has a NOCOW attribute set 
on it?
