From: Boyd Waters <waters.boyd@gmail.com>
Subject: Re: btrfs and 1 billion small files
Date: Mon, 7 May 2012 04:06:46 -0600
Message-ID: <9EC89864-505F-4821-90F9-389B8C65C4F2@gmail.com>
References: <711331964.2091.1336382892940.JavaMail.root@zimbra.interconnessioni.it> <7802030.zmTeQQDGHD@bursa01>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Cc: Alessio Focardi <alessiof@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <7802030.zmTeQQDGHD@bursa01>
List-ID: <linux-btrfs.vger.kernel.org>

Use a directory hierarchy. Even if the filesystem handles a flat structure effectively, userspace programs will choke on tens of thousands of files in a single directory. For example 'ls' will try to lexically sort its output (very slowly) unless given the command-line option not to do so.

Sent from my iPad

On May 7, 2012, at 3:58 AM, Hubert Kario <hka@qbs.com.pl> wrote:

> I'm not sure about limits to size of directory, but I'd guess that going over 
> few tens of thousands of files in single flat directory will have speed 
> penalties
