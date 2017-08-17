Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f53.google.com ([209.85.213.53]:36875 "EHLO
        mail-vk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752632AbdHQUew (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 16:34:52 -0400
Received: by mail-vk0-f53.google.com with SMTP id r199so26298040vke.4
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Aug 2017 13:34:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTbaU=A5RQgS1F41tH2m558PgyUb0Gm4WStpA=PM3Ykrg@mail.gmail.com>
References: <CAJCQCtRGUBWD6Mw6pAiKGAPgGz+vqy3sgmbEBDETPYsxJw8G7w@mail.gmail.com>
 <b14a36dd-fcab-a38b-cbf9-adbd096da3a3@gmx.com> <1502496618.6092.6.camel@scientia.net>
 <20170812074248.GA3352@infradead.org> <e560ba2d-ad11-abe6-bb3a-788d7b5a7562@gmx.com>
 <1502713484.3608.1.camel@scientia.net> <b0e0e9e4-5b7f-ac84-b05c-8724762b16ea@gmail.com>
 <49ebcfb9-b0c8-0feb-3570-a5b19c3e3b33@cobb.uk.net> <53633949-b04b-ec5c-f300-c0b702d22374@gmail.com>
 <1502740488.5384.5.camel@scientia.net> <20170816131230.GA28619@clm-mbp.thefacebook.com>
 <51e051fa-3731-d2fe-7eab-cb324fd38576@gmx.com> <CAJCQCtSgGdsctmiJ4Sq+E5Qr1aoC87EiFUrkH7Eeu8GTZ6XvyQ@mail.gmail.com>
 <CAP8EXU2VnPMp4TdXo=GcNQ6Y1ymTMsO=t8+AEEM=LygRpTUWMA@mail.gmail.com>
 <118e3a18-bf01-919f-0e21-7101313cd164@gmail.com> <CAJCQCtTbaU=A5RQgS1F41tH2m558PgyUb0Gm4WStpA=PM3Ykrg@mail.gmail.com>
From: GWB <gwb@2realms.com>
Date: Thu, 17 Aug 2017 15:34:10 -0500
Message-ID: <CAP8EXU3TaY6Pts_CpNo+9g8UmvaoRwHtitS6omOgPM4oj0Eanw@mail.gmail.com>
Subject: Re: RedHat 7.4 Release Notes: "Btrfs has been deprecated" - wut?
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Peter Grandi <pg@btrfs.list.sabi.co.uk>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yep, and thank you to Suse, Fujitsu, and all the contributors.

I suppose we can all be charitable when reading this from the Red Hat
Whitepaper at:

https://www.redhat.com/whitepapers/rha/gfs/GFS_INS0032US.pdf:

<<
 Red Hat GFS is the world’s leading cluster file system for Linux.
>>

If that is GFS2, it is a different use case than Gluster
(https://www.redhat.com/en/technologies/storage).  So perhaps
marketing might tweak that a little bit, maybe:

<<
 Red Hat GFS is the world’s leading cluster file system for Linux for
Oracle RAC Database Clustering.
>>

But you can see how Oracle might quibble with that.  So Red Hat goes
as far as it can in the Whitepaper:

<<
 Red Hat GFS simplifies the installation, configuration, and on-going
maintenance of the SAN infrastructure necessary for Oracle RAC
clustering. Oracle tables, log files, program files, and archive
information can all be stored in GFS files, avoiding the complexity
and difficulties of managing raw storage devices on a SAN while
achieving excellent performance.
>>

Which avoids a comparison between, say, an Oracle Sparc server
(probably made by Fujitsu) hosting Oracle Rack Clusters on Solaris.
Given the price of Oracle's sparc servers, Red Hat may be as good as
an Oracle RAC DB server can get for a price less than the annual
budget of a small country.

Well, great news, Austin and Chris, that clears it up for me, and now
I know of yet another use case for btrfs as the dmu for Gluster.  So,
again, I'm not too worried about Red Hat deprecating btrfs, given the
number of supporters and developers.  If Oracle or Suse drops out,
then I would worry.

Gordon

On Thu, Aug 17, 2017 at 2:00 PM, Chris Murphy <lists@colorremedies.com> wrote:
> On Thu, Aug 17, 2017 at 5:47 AM, Austin S. Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>
>> Also, I don't think I've ever seen any patches posted from a Red Hat address
>> on the ML, so I don't think they were really all that involved in
>> development to begin with.
>
> Unfortunately the email domain doesn't tell the whole story who's
> backing development, the company or the individual.
>
> [chris@f26s linux]$ git log --since=”2016-01-01” --pretty=format:"%an
> %ae" --no-merges -- fs/btrfs | sort -u | grep redhat
> Andreas Gruenbacher agruenba@redhat.com
> David Howells dhowells@redhat.com
> Eric Sandeen sandeen@redhat.com
> Jeff Layton jlayton@redhat.com
> Mike Christie mchristi@redhat.com
> Miklos Szeredi mszeredi@redhat.com
> $
>
>
>
>> GFS and GlusterFS are different technologies, unless Red Hat's marketing
>> department is trying to be actively deceptive.
>
> https://www.redhat.com/en/technologies/storage
>
> Seems very clear. I don't even see GFS or GFS2 on here. It's Gluster and Ceph.
>
>
>>
>> SUSE is also pretty actively involved in the development too, and I think
>> Fujitsu is as well.
>
>
>
>>>
>>>
>>> I'm not too worried.  I'll keep using btrfs as it is now, within the
>>> limits of what it can consistently do, and do what I can to help
>>> support the effort.  I'm not a file system coder, but I very much
>>> appreciate the enormous amount of work that goes into btrfs.
>>>
>>> Steady on, ButterFS people.  Back now to cat videos.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Big bunch of SUSE contributions (yes David Sterba is counted three
> times here), and Fujitsu.
>
> [chris@f26s linux]$ git log --since=”2016-01-01” --pretty=format:"%an
> %ae" --no-merges -- fs/btrfs | sort -u | grep suse
> Borislav Petkov bp@suse.de
> David Sterba dsterba@suse.com
> David Sterba DSterba@suse.com
> David Sterba dsterba@suse.cz
> Edmund Nadolski enadolski@suse.com
> Filipe Manana fdmanana@suse.com
> Goldwyn Rodrigues rgoldwyn@suse.com
> Guoqing Jiang gqjiang@suse.com
> Jan Kara jack@suse.cz
> Jeff Mahoney jeffm@suse.com
> Jiri Kosina jkosina@suse.cz
> Mark Fasheh mfasheh@suse.de
> Michal Hocko mhocko@suse.com
> NeilBrown neilb@suse.com
> Nikolay Borisov nborisov@suse.com
> Petr Mladek pmladek@suse.com
>
> [chris@f26s linux]$ git log --since=”2016-01-01” --pretty=format:"%an
> %ae" --no-merges -- fs/btrfs | sort -u | grep fujitsu
> Lu Fengqi lufq.fnst@cn.fujitsu.com
> Qu Wenruo quwenruo@cn.fujitsu.com
> Satoru Takeuchi takeuchi_satoru@jp.fujitsu.com
> Su Yue suy.fnst@cn.fujitsu.com
> Tsutomu Itoh t-itoh@jp.fujitsu.com
> Wang Xiaoguang wangxg.fnst@cn.fujitsu.com
> Xiaoguang Wang wangxg.fnst@cn.fujitsu.com
> Zhao Lei zhaolei@cn.fujitsu.com
>
>
> Over the past 18 months, it's about 100 Btrfs contributors, 71 ext4,
> 63 XFS. So all three have many contributors. That of course does not
> tell the whole story by any means.
>
> --
> Chris Murphy
