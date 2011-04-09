From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: wrong values in "df" and "btrfs filesystem df"
Date: 09 Apr 2011 19:05:00 +0200
Message-ID: <BjX0k26y1uB@helmut.hullen.de>
References: <1302366997.19697.3.camel@nayuki>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302366997.19697.3.camel@nayuki>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Calvin,

Du meintest am 09.04.11:

>>> Then I work on it, copy some new files, delete some old files - all
>>> works well. Only
>>>
>>>   df /srv/MM
>>>   btrfs filesystem df /srv/MM
>>>
>>> show some completely wrong values:

[...]

> And I just drew up a picture which I think should help explain it a
> bit, too: http://www.kepstin.ca/dump/btrfs-alloc.png

Nice picture. But it doesn't solve the problem that I need a reliable  
information about the free/available space. And I prefer asking with  
"df" for this information - "df" should work in the same way for all  
filesystems.

Viele Gruesse!
Helmut
