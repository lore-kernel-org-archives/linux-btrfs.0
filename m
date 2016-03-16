Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:34193 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbcCPEWW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 00:22:22 -0400
Received: by mail-io0-f172.google.com with SMTP id m184so49804830iof.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2016 21:22:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1557fe0b-bbcc-c125-5220-46a56e936590@mokrynskyi.com>
References: <a55e81de-412b-c269-775d-3f8e0d96d7a9@mokrynskyi.com>
	<72cb240a-fdb2-c38b-adb1-2b72847ab29a@mokrynskyi.com>
	<CAPmG0jZvioaxdr4FNHRQJTDZwuxq5EwUTay+VB=c+hKAzdDGYg@mail.gmail.com>
	<ce805cd7-422c-ab6a-fbf8-18a304aa640d@mokrynskyi.com>
	<CAPmG0jbRmWeHvL4cUzhPBAfA=_Ue03uC-pLE4O-u5bzFF_kzEQ@mail.gmail.com>
	<5240211f-27b7-2c87-41e7-c10953374921@mokrynskyi.com>
	<CAPmG0jZwapQ1=V-dHMEEwMYQUjb4+1M102eo96XQeJQV1JoxeQ@mail.gmail.com>
	<1557fe0b-bbcc-c125-5220-46a56e936590@mokrynskyi.com>
Date: Tue, 15 Mar 2016 22:22:21 -0600
Message-ID: <CAJCQCtSMBxs7mufAxXLvwuCt6=76BBWAbnP0ZZH5G_yid_botg@mail.gmail.com>
Subject: Re: Major HDD performance degradation on btrfs receive
From: Chris Murphy <lists@colorremedies.com>
To: Nazar Mokrynskyi <nazar@mokrynskyi.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Maybe a starting point.
https://oss.oracle.com/~mason/seekwatcher/

This shows write patterns, not current state fragmentation. So it's
less useful for what you're asking, and more useful for what I was
suggesting as a batched snapshot delete strategy.


Chris Murphy
