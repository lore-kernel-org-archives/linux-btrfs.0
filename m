Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:36647 "EHLO
	mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbcDOGvn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 02:51:43 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 50785AC01FD
	for <linux-btrfs@vger.kernel.org>; Fri, 15 Apr 2016 15:51:39 +0900 (JST)
Subject: Re: RFE: btrfs subvolume list -t, include marker for snapshots, and
 whether they are ro
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtSUj0fcsH7AUREnm7KzdDZiL2pW9MpSkKiQBcV9-J9nXQ@mail.gmail.com>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <57108F74.3050802@jp.fujitsu.com>
Date: Fri, 15 Apr 2016 15:51:32 +0900
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSUj0fcsH7AUREnm7KzdDZiL2pW9MpSkKiQBcV9-J9nXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/04/15 10:55, Chris Murphy wrote:
> Hi,
>
> I'm realizing instead of doing 'btrfs subvolume -t' and then 'btrfs
> subvolume -tr' and comparing, it would be better if -t just had a
> column for whether a subvolume is ro. And maybe it's useful to know if
> a subvolume is a snapshot or not (?). I'm not super picky about the
> last one. But being able to see if it's ro or not is a nice to have.
>
> In particular on openSUSE with snapper where there's a prolific amount
> of snapshots, and the naming convention doesn't indicate whether
> something is ro or not.
>

Although I'm not sure whether such changes is acceptable or not,
just FYI, you can list subvols with ro flags by the following script.

================================================================
#!/bin/ruby

IO.popen("btrfs sub list -t " + ARGV[0]) {|p_list|
   puts p_list.gets.chomp + "ro"
   puts p_list.gets.chomp + "--"
   ro = ''
   p_list.each { |l|
     l.chomp!
     path = l.split[3]
     IO.popen("btrfs property get #{ARGV[0]+path} | sed -nre 's/^ro=(true|false)$/\\1/p'") { |p_prop|
       ro = p_prop.gets
       ro = "false" if ro.nil?
     }

     puts l + "\t" + ro
   }
}
================================================================

# NOTE: It's not well tested.

sample output:
================================================================
# ./sub-list-with-ro.rb /
ID      gen     top level       path    ro
--      ---     ---------       ----    --
257     48672   5               root    false
259     48623   257             var/lib/machines        false
452     36540   257             root/snaps/root-2016-03-18      true
457     45676   257             root/snaps/root-2016-04-08      true
================================================================

Thanks,
Satoru
