Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw8a-gabriella.wadns.net ([196.220.39.91]:24997 "EHLO
	fw8a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750889AbaCVTx1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Mar 2014 15:53:27 -0400
Message-ID: <532DEA2D.1090606@swiftspirit.co.za>
Date: Sat, 22 Mar 2014 21:53:17 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: Send/Receive howto and script for others to use (was Re: Is anyone
 using btrfs send/receive)
References: <20131228171943.GE19863@merlins.org> <20131228173730.GA7234@carfax.org.uk> <20131228180758.GF19863@merlins.org> <20140107104951.GL10936@merlins.org> <20140107105329.GE15634@carfax.org.uk> <20140108080206.GV10936@merlins.org> <20140321172904.GE28005@merlins.org> <532DE805.7040407@swiftspirit.co.za>
In-Reply-To: <532DE805.7040407@swiftspirit.co.za>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/03/22 09:44 PM, Brendan Hide wrote:
> On 2014/03/21 07:29 PM, Marc MERLIN wrote:
>>
>
> Hi, Marc
>
> Feel free to use ideas from my own script. Some aspects in my script 
> are more mature and others are frankly pathetic. ;)
>
> There are also quite a lot of TODOs throughout my script that aren't 
> likely to get the urgent attention they deserve. It has been slowly 
> evolving over the last two weeks.
>
> http://swiftspirit.co.za/scripts/btrfs-snd-rcv-backup
>
I forgot to include some notes:

The script depends on a "config" file at /etc/btrfs-backup/paths.conf 
which is supposed to contain the paths as well as some parameters. At 
present the file consists solely of the following paths as these are all 
separate subvolumes in my test system:
"/
/home
/usr
/var
"

The snapshot names on source and backup are formatted as below. This 
way, daylight savings doesn't need any special treatment:
__2014-03-17-23h00m01s+0200
__2014-03-18-23h00m01s+0200
__2014-03-19-23h00m01s+0200
__2014-03-20-23h00m02s+0200
__2014-03-21-23h00m01s+0200
_home_2014-03-17-23h00m01s+0200
_home_2014-03-18-23h00m01s+0200
_home_2014-03-19-23h00m01s+0200
_home_2014-03-20-23h00m02s+0200
_home_2014-03-21-23h00m01s+0200
_usr_2014-03-17-23h00m01s+0200
_usr_2014-03-18-23h00m01s+0200
_usr_2014-03-19-23h00m01s+0200
_usr_2014-03-20-23h00m02s+0200
_usr_2014-03-21-23h00m01s+0200
_var_2014-03-17-23h00m01s+0200
_var_2014-03-18-23h00m01s+0200
_var_2014-03-19-23h00m01s+0200
_var_2014-03-20-23h00m02s+0200
_var_2014-03-21-23h00m01s+0200



-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

