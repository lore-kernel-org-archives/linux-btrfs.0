Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34537 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbbFZBLH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 21:11:07 -0400
Message-ID: <558CA6A0.20401@oracle.com>
Date: Fri, 26 Jun 2015 09:10:56 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Omar Sandoval <osandov@fb.com>, linux-btrfs@vger.kernel.org
CC: David Sterba <dsterba@suse.cz>, Chris Mason <clm@fb.com>
Subject: Re: [PATCH 0/2] btrfs device remove alias
References: <cover.1435161735.git.osandov@fb.com>
In-Reply-To: <cover.1435161735.git.osandov@fb.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


while on this. its also good idea to create alias for

   btrfs replace start -> btrfs device replace.

any comments ?


On 06/25/2015 12:09 AM, Omar Sandoval wrote:
> The opposite of btrfs device add is btrfs device delete. This really
> should be btrfs device remove.
>
> Changes from v1:
> - Add support for flags to cmd_struct and a CMD_ALIAS flag which only
>    prints the one-line usage string
> - Rearrange the command wrappers in a way that could be made generic if
>    needed
>
> Thanks!
>
> Omar Sandoval (2):
>    btrfs-progs: replace struct cmd_group->hidden with flags
>    btrfs-progs: alias btrfs device delete to btrfs device remove
>
>   Documentation/btrfs-device.asciidoc |  5 ++++-
>   cmds-device.c                       | 35 ++++++++++++++++++++++++++---------
>   cmds-filesystem.c                   |  2 +-
>   commands.h                          |  9 +++++++--
>   help.c                              | 12 +++++++-----
>   5 files changed, 45 insertions(+), 18 deletions(-)
>
