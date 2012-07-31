Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38409 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab2GaSlG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 31 Jul 2012 14:41:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SwHNS-0003a1-Ai
	for linux-btrfs@vger.kernel.org; Tue, 31 Jul 2012 20:41:06 +0200
Received: from rain.gmane.org ([80.91.229.7])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 20:41:06 +0200
Received: from eternaleye+usenet by rain.gmane.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Jul 2012 20:41:06 +0200
To: linux-btrfs@vger.kernel.org
From: Alex Elsayed <eternaleye+usenet@gmail.com>
Subject: An easier-to-use interface for btrfs-restore?
Date: Tue, 31 Jul 2012 11:40:52 -0700
Message-ID: <jv98rl$vse$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In using btrfs-restore, I've found that much of the time the interface is a 
poor match for what I'm trying to do. It works fine in the simplest cases 
where you want to extract everything, but wanting to extract a subset of the 
files in a directory is more difficult, and it gets more complicated from 
there.

My solutions was to hack up (not very well) a btrfs-list-files program, feed 
it to a Perl script to pick out the files I wanted and turn them into 
(sanitized) regexes, and feed the results to btrfs-restore in a loop.

I think that, while my implementation of this was subpar, the idea deserves 
wider consideration.

The idea is to split the restore utility into two components:

A 'find'-style listing utility
    Supports various matching operations such as -name, -regex, etc.
    Supports -print and -print0
    Does not support -exec, -execdir, -delete, etc.

An extraction tool
    Accepts a list of files in argv[] or on STDIN
        STDIN supports both newline- and null-terminated operation
    Does simple string matching
    Extracts the named files

Benefits:
    Simplicity:
        The find utility only needs to care about walking dentries and 
matching patterns
        The extraction utility just needs to compare strings and extract 
data on success
    Usability:
        Find has a reasonably well-known and well-understood interface
        A simple extractor you just feed a list of files and directories to 
is easier to grok for a new user.
        Eliminate the annoying way the current interface requires splitting 
up the path components of files into alternations
    Efficiency:
        The extractor can build up a trie of files to be matched
        A near-arbitrary-size list of files can be extracted in two passes 
(find names, extract files) without undue complexity, negating the need to 
either build truly horrendous regexes or extract in a loop and take the 
performance hit.

