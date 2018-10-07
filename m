Return-Path: <SRS0=s/W2=MT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81DA7C65C1D
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 13:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BC132075C
	for <linux-btrfs@archiver.kernel.org>; Sun,  7 Oct 2018 13:45:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BC132075C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=applied-asynchrony.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbeJGUxI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 7 Oct 2018 16:53:08 -0400
Received: from mail02.iobjects.de ([188.40.134.68]:58294 "EHLO
        mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbeJGUxI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2018 16:53:08 -0400
X-Greylist: delayed 505 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Oct 2018 16:53:07 EDT
Received: from tux.wizards.de (p3EE2F45F.dip0.t-ipconnect.de [62.226.244.95])
        by mail02.iobjects.de (Postfix) with ESMTPSA id 25CF34161F58
        for <linux-btrfs@vger.kernel.org>; Sun,  7 Oct 2018 15:37:27 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.wizards.de (Postfix) with ESMTP id A942CED3607
        for <linux-btrfs@vger.kernel.org>; Sun,  7 Oct 2018 15:37:26 +0200 (CEST)
To:     linux-btrfs <linux-btrfs@vger.kernel.org>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: Monitoring btrfs with Prometheus (and soon OpenMonitoring)
Organization: Applied Asynchrony, Inc.
Message-ID: <02416de6-1c8c-235d-f59d-322bbcd68105@applied-asynchrony.com>
Date:   Sun, 7 Oct 2018 15:37:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


The Prometheus statistics collection/aggregation/monitoring/alerting system
[1] is quite popular, easy to use and will probably be the basis for the
upcoming OpenMetrics "standard" [2].

Prometheus collects metrics by polling host-local "exporters" that respond
to http requests; many such exporters exist, from the generic node_exporter
for OS metrics to all sorts of application-/service-specific varieties.

Since btrfs already exposes quite a lot of monitorable and - more
importantly - actionable runtime information in sysfs it only makes sense
to expose these metrics for visualization & alerting. I noodled over the
idea some time ago but got sidetracked, besides not being thrilled at all
by the idea of doing this in golang (which I *really* dislike).

However, exporters can be written in any language as long as they speak
the standard response protocol, so an alternative would be to use one
of the other official exporter clients. These provide language-native
"mini-frameworks" where one only has to fill in the blanks (see [3]
for examples).

Since the issue just came up in the node_exporter bugtracker [3] I
figured I ask if anyone here is interested in helping build a proper
standalone btrfs_exporter in C++? :D

..just kidding, I'd probably use python (which I kind of don't really
know either :) and build on Hans' python-btrfs library for anything
not covered by sysfs.

Anybody interested in helping? Apparently there are also golang libs
for btrfs [5] but I don't know anything about them (if you do, please
comment on the bug), and the idea of adding even more stuff into the
monolithic, already creaky and somewhat bloated node_exporter is not
appealing to me.

Potential problems wrt. btrfs are access to root-only information,
like e.g. the btrfs device stats/errors in the aforementioned bug,
since exporters are really supposed to run unprivileged due to network
exposure. The S.M.A.R.T. exporter [6] solves this with dual-process
contortions; obviously it would be better if all relevant metrics were
accessible directly in sysfs and not require privileged access, but
forking a tiny privileged process every polling interval is probably
not that bad.

All ideas welcome!

cheers,
Holger

[1] https://www.prometheus.io/
[2] https://openmetrics.io/
[3] https://github.com/prometheus/client_python,
     https://github.com/prometheus/client_ruby
[4] https://github.com/prometheus/node_exporter/issues/1100
[5] https://github.com/prometheus/node_exporter/issues/1100#issuecomment-427651028
[6] https://github.com/cloudandheat/prometheus_smart_exporter
