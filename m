Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34437 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab3CTUIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Mar 2013 16:08:54 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: Integration branch of btrfs-progs 2013-03-20
Date: Wed, 20 Mar 2013 21:08:49 +0100
References: <20130318173326.GO7229@twin.jikos.cz> <20130320174118.GC31559@twin.jikos.cz> (sfid-20130320_195608_306019_6672DED3)
In-Reply-To: <20130320174118.GC31559@twin.jikos.cz>
Cc: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201303202108.50024.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 20. März 2013 schrieb David Sterba:
> Hi,
> 
> finally removing the obsolete utilities, adding the fragmentation
> visualisation tool in exchange, setting of io priority for scrub, few
> more fixes and updates to the build system.

The fragmentation visuation tool works nicely. Tried it on about 200 GiB
/home, almost no fragmentation, some 3-4%, but mostly 0.something%,
and on about 20 GiB root, were some chunks were fragmented upto 30-40%.

What kind of fragmentation does the tool count? From what I understand
by looking at the source, extent fragmentation?

 82 static void
 83 print_bg(FILE *html, char *name, u64 start, u64 len, u64 used, u64 flags,
 84 »······· u64 areas)
 85 {
 86 »·······double frag = (double)areas / (len / 4096) * 2;
 87                                                                                                                                                
 88 »·······fprintf(html, "<p>%s chunk starts at %lld, size is %s, %.2f%% used, "
 89 »·······»·······      "%.2f%% fragmented</p>\n", chunk_type(flags), start,
 90 »·······»·······      pretty_sizes(len), 100.0 * used / len, 100.0 * frag);
 91 »·······fprintf(html, "<img src=\"%s\" border=\"1\" />\n", name);
 92 }

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
