Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755991Ab3H2Rfb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Aug 2013 13:35:31 -0400
Date: Thu, 29 Aug 2013 10:35:19 -0700
From: Zach Brown <zab@redhat.com>
To: Hugo Mills <hugo@carfax.org.uk>, Chris Murphy <lists@colorremedies.com>,
        Nick Lee <email@nickle.es>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Question: How can I recover this partition? (unable to find
 logical $hugenum len 4096)
Message-ID: <20130829173519.GN26818@lenny.home.zabbo.net>
References: <5EB2ECAC-9A8C-4403-8630-944B646DE3B8@nickle.es>
 <DD09B4EA-9F87-4D18-8B7A-EEF2FFD6A7FE@nickle.es>
 <EC688346-BA9C-4077-A301-12FFE5463121@colorremedies.com>
 <A19C7607-0BF4-4C40-B9A3-F94144034B72@colorremedies.com>
 <6A12FF1B-5E1A-4F6F-92DA-41E52152E6F2@nickle.es>
 <EA37CDC0-8D44-45ED-8266-0E1CDECBE3EE@nickle.es>
 <CA17D410-C4E1-4F82-A0FF-CFA6D725E5D2@colorremedies.com>
 <CAGURm2FS=YTuBpbrg7BV=Un8ZCp9xYZae-WuqhjV29xXA7e0jw@mail.gmail.com>
 <E76A410A-0CEF-47D7-A501-E2DDF0230735@colorremedies.com>
 <20130826193110.GO3115@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130826193110.GO3115@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>    If those fail, then look in dmesg for errors relating to the log
> tree -- if that's corrupt and can't be read (or causes a crash), use
> btrfs-zero-log.

In a bit of a tangent:

btrfs-zero-log throws away data that fsync/sync could have previously
claimed was stable on disk.

Given how often this is thrown around as a solution to a broken
partition, should the tool jump up and down and make it clear that it's
about to roll the file system back?  This seems like relevant
information.

Right now, as far as I can tell, it's completely undocumented and
silent.

- z
