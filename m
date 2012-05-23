Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:20684 "EHLO
	sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab2EWOPZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 May 2012 10:15:25 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
	by sed198n136.sedsystems.ca  with ESMTP id q4NEFOt4014468
	(version=TLSv1/SSLv3 cipher=DHE-DSS-AES256-SHA bits=256 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2012 08:15:24 -0600 (CST)
Received: from [198.169.180.30] (sed198n30.SEDSystems.ca [198.169.180.30])
	by barney.sedsystems.ca (8.13.1/8.13.1) with ESMTP id q4NEFOvb001460
	for <linux-btrfs@vger.kernel.org>; Wed, 23 May 2012 08:15:24 -0600
Message-ID: <4FBCF08E.10204@sedsystems.ca>
Date: Wed, 23 May 2012 08:13:34 -0600
From: Henry Bakker <bakker@sedsystems.ca>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Could btrfs-restore be extended to also restore file dates?
References: <4FBC082D.9020707@sedsystems.ca> <20120523090748.GM24394@twin.jikos.cz>
In-Reply-To: <20120523090748.GM24394@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm sure restoring all those fields would be functionality that most
server admins would want. If anyone on this list can add it, then you
have my thanks.

On 5/23/2012 3:07 AM, David Sterba wrote:
> On Tue, May 22, 2012 at 03:42:05PM -0600, Henry Bakker wrote:
>> Any possibility of getting btrfs-restore to also restore the files
>> timestamp?
> 
> Quick look, yes it is possible and quite straightforward. The function
> restore.c:copy_file has direct access to the found on-disk inode item
> and can access the time fileds, then simply setting them for the file.
> Maybe it could restore more, like uid, gid or mode.
> 
> 
> david
> 
> 
