Received: from mail-yx2-f1.google.com (mail-yx2-f1.google.com [74.125.224.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D293F23D1
	for <linux-btrfs@vger.kernel.org>; Wed,  1 Jul 2026 23:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782949460; cv=none; b=CDeHrpxlBAa1ei8p9VoI0JPRa2JnIpzK++AAk5nQuOd3qqthDG073U8k5UHyRPcKh+Rrrdz6KaB0NOPfHrSGRy9nNF+4IO6NTj6qAe+TLWzGA4RF+LnlTcKbehkBJP0l41wuXCi6T3OzGScub1hkZPC0Vfk94kog934WFzu6MUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782949460; c=relaxed/simple;
	bh=4XZkSkC3QlAOEWhMXJEUxtmWxRtjqMmLeUGr9o50oyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVTYmZX6KsrNNZEdRrlNszlkXm0mXQMpuRq7NZDNf+AgOfCLOEsT1yzRRTUp7x2NmruuZT5PDwHreCp8p9dPbKT+a09NhSuZY4gWiY+GYwgLqJixZd+81BVv4xb4HsoCj8EceonKCsyJrH+nYOT0ZMmAykiJ6CtcO0XuxKSB738=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=objp6pkQ; arc=none smtp.client-ip=74.125.224.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="objp6pkQ"
Received: by mail-yx2-f1.google.com with SMTP id 00721157ae682-80247dc83e0so8738407b3.1
        for <linux-btrfs@vger.kernel.org>; Wed, 01 Jul 2026 16:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782949458; x=1783554258; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G+lRzVKM3rxWIeA0xqidur9ZTphZLEKeOdJI1P0EvDk=;
        b=objp6pkQvpO+zDl05sO/yUGiD01A/dLqAlaa2wdL4dsTkc8eC+e1OtRDceVkyJsQcx
         6FhiIo2/IXs39zFTR3x3x+dpbGPzW5TiNbcgFGzW0DnZp2IxB4q/RVLG27BpZiLtyvTr
         nPSZKMFUJ6oqHY7eORGeieyPRohKfy4RY4bhqYTQYxrLV9aphQo2ZruPXNTuafhSwOR7
         yE1ZTS/gCoG/2rs84UQkzszcz8lTn9QrJB0pVy1kEvS+ciQXoiHrLXGQxUryH3z9ndv8
         hI66DOGrg2sEPa1g8aIcx44yFxsZW/VLnOxcfNVy7Jnsfe9eDqlbFOTAdZt3MUvP/QgQ
         Xk0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782949458; x=1783554258;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G+lRzVKM3rxWIeA0xqidur9ZTphZLEKeOdJI1P0EvDk=;
        b=Y5AlxoQNSwGhJqgRCbdCJ2iA+dX5QOUfzNSIC1F+B+RUNDJkP9io1EY/OQkR+6mbTA
         +Zh5wb9oxI9FAn4Hc1rLzr8sI+Hp3vXVz01C9olWauRIc5nSeCTOO1jtggjhuZdm1445
         uTKHwegmWvXry5kCufF+8YgQHbXNtARLQQewDbM1jj9JbIMwgC68aU4qaZJlcpKMAQLo
         7J8Mz7Exli9ae01PwjuYGf54pQ+3EnqoJfIOAqkSyOx+//PIaoxFIuvYccw/64gMfUy1
         SFzu2ZZo4fZ0lB+80HoW1AElHOpyPgcglyY2pQV1xNdrDsA8YOeHCf+SMMBQJCyPJZYH
         JhyA==
X-Forwarded-Encrypted: i=1; AHgh+Ro7J/G3BSGwBOZ2pEfvrKqUk4TAWwkFKsfx363FWPvS4+Q0RLGWQtow4Z752que3le1uURBUsr+gzPJiw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywi1nsItdxUniOupn8zIlYlgpGWRGUq1oITNVzy9tPS+WVf1gt5
	cYPyc8K/gBdoFCpera1OiAWEFH6ko9Dqbd1dzQk9QesERtRef7mWgPy0uOcgF7Ir
X-Gm-Gg: AfdE7clpCjhuseC31JBsfmtWRX5uAgigaMkSoTZiosEcgDOWVc51LNdomAzSJbcwMJm
	4j/BJcpNnPwUk8rYK2r0O4LMSFwT4jmsNni/VYXIvh/qgv8oZwx4wlR+mzOUNPoephcguPbAPXA
	LA/rY/DYxuWZdj360wRg7ww1PS6cxkmIO6ufNOS5k7OORsVMwGHot3TsKWnYNgoqn1cMxF/2Ki6
	dJcBl3x6y//I3Vc/Y44aVRPjuE82iL0y9v2MJR3XaQtzCQyVAM99j1ZDnVL3lnb+2f007NqNlTM
	ZLRBea2JJspwMuduFXQBAM3X7lbbFImoU6L4HwYe3UVAl00qK7RnfOcr310omwDlMPiQ5t9TzLE
	UFqxh7LUw2Jg+F+VmSjEmXo/P02y71YSrpQ1CzQAu+qV2/Id1JAn6Sou7J/34+nkOa32H2MrtuL
	dXfC2PpaU=
X-Received: by 2002:a05:690c:6c92:b0:80c:2874:67ce with SMTP id 00721157ae682-812e9cc6e16mr43982877b3.30.1782949454439;
        Wed, 01 Jul 2026 16:44:14 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:5d::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8144b52da92sm6074367b3.33.2026.07.01.16.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 16:44:13 -0700 (PDT)
From: Leo Martins <loemra.dev@gmail.com>
To: kernel test robot <oliver.sang@intel.com>,
	oe-lkp@lists.linux.dev
Cc: lkp@intel.com,
	linux-btrfs@vger.kernel.org,
	kernel-team@fb.com,
	David Sterba <dsterba@suse.com>
Subject: Re: [linux-next:master] [btrfs]  9a8eec6165:  fio.write_iops 22.6% regression
Date: Wed,  1 Jul 2026 16:44:11 -0700
Message-ID: <20260701234412.4048647-1-loemra.dev@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <202603112240.f7605968-lkp@intel.com>
References: <202603112240.f7605968-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Oliver,

Thanks for the report. I'm aware of this regression and the cause is
understood: the flagged commit adds a per-COW xarray store on every
COW'd metadata block, and on this single-task 4k randwrite ftruncate
workload that store is what costs the write_iops.

A fix has been posted to linux-btrfs that replaces the xarray with a
non-allocating fixed inline buffer and recovers the lost throughput:

  "btrfs: replace writeback inhibition xarray with a fixed inline buffer"

It carries the Reported-by and Closes tags pointing at this report.

Thanks,
Leo
