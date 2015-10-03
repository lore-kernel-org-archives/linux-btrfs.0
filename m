Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-17.italiaonline.it ([212.48.25.145]:49615 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751676AbbJCKG6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 3 Oct 2015 06:06:58 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [PATCH 4/4] btrfs-progs: change -t option for subvolume list to
 print a simple space-separated table (making it machine-readable)
References: <1443804083-876-1-git-send-email-axel@tty0.ch>
 <1443804083-876-5-git-send-email-axel@tty0.ch> <560FA665.6000700@libero.it>
To: axel@tty0.ch
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <560FA8C0.6010400@inwind.it>
Date: Sat, 3 Oct 2015 12:06:56 +0200
MIME-Version: 1.0
In-Reply-To: <560FA665.6000700@libero.it>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-10-03 11:56, Goffredo Baroncelli wrote:
> On 2015-10-02 18:41, axel@tty0.ch wrote:
>> Old implementation used tabs "\t", and tried to work around problems
>> by guessing amount of tabs needed (e.g. "\t\t" after top level", with
>> buggy output as soon as empty uuids are printed). This will never work
>> correctly, as tab width is a user-defined setting in the terminal.
> 
> 
> Why not use string_table() and table_*() functions  ? 

Hem sorry, .... create_table() and table_*() functions (see string-table.h)

[...]


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
