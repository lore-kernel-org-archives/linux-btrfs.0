Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C7030F552;
	Tue, 17 Feb 2026 09:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.149.199.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771321067; cv=none; b=TVhRRNLgSpupRh+WkjnLJUoZxqkGf/4BybFauLVjQdZuzpZIYlcYioQWx4pvAh8vTM+WX2XkJXSwhQRUwGJvuk0DZX3GB3996a//NFhB9IQS2ATML9oM3wtWFbJA98ynH3wL7tNuQW+PnE6jQRM6gRbOu04tL2U/62X6wX24CAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771321067; c=relaxed/simple;
	bh=ZNE2cjVm9h/GNVlN/tgzzuMRCEo7DyDq5EfAwVtnSxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NnONeugbRNoNv9DQPU7zOZ3Wk5VnOU3zlNl5e/QzP/8v/SXrteGUyVHaeVoewEGNpuNtKCdovfECnSpx/njlLktNw+XVnOxWETcKrk40mV+QAsckNgaRdYsf7sDvT9HESr/5N7QQiQtbxfLycU55xBXCvGBW4+BaHTMOkbMYOmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru; spf=pass smtp.mailfrom=ispras.ru; dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b=MwDhNPH9; arc=none smtp.client-ip=83.149.199.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ispras.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ispras.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ispras.ru header.i=@ispras.ru header.b="MwDhNPH9"
Received: from localhost (unknown [79.139.249.127])
	by mail.ispras.ru (Postfix) with ESMTPSA id 7754540ACDE4;
	Tue, 17 Feb 2026 09:37:36 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 7754540ACDE4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
	s=default; t=1771321056;
	bh=60hLXG05tv33tUYdJE9WudTXXtDcQhx/dk5Ikbs44tk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MwDhNPH91eBjAqjmR86Z9HC9rTp/qv4yub9FH+RwlhEKpcf9uq0j0a2fSl0YWw8C4
	 XMRxOlJiq/kK7QdpLer1SczZi3zHXCftsxZt7NZY6bnbfIrXMyHkGw/XryVdC3TqIs
	 W4Cwx40kfIt5DINWUKHZDoeuTTbj2UtOanHTNQEU=
Date: Tue, 17 Feb 2026 12:37:36 +0300
From: Fedor Pchelkin <pchelkin@ispras.ru>
To: Burenchev Evgenii <EBurenchev@orionsoft.ru>
Cc: "clm@fb.com" <clm@fb.com>, "dsterba@suse.com" <dsterba@suse.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, 
	"lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH] btrfs: remove dead assignment to dirid in
 btrfs_search_path_in_tree()
Message-ID: <20260217123442-4dc46ffd577ed43dac0f636d-pchelkin@ispras>
References: <3f1d7281b3004c6baa24a531b409c466@orionsoft.ru>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3f1d7281b3004c6baa24a531b409c466@orionsoft.ru>

Hi there,

On Mon, 16. Feb 16:16, Burenchev Evgenii wrote:
> From ff2df73ba6483b0dc67b3ed89d2a43c49f1c2eb8 Mon Sep 17 00:00:00 2001
> From: Evgenii Burenchev <eburenchev@orionsoft.ru>
> Date: Mon, 16 Feb 2026 18:39:30 +0300
> Subject: [PATCH] btrfs: remove dead assignment to dirid in
>  btrfs_search_path_in_tree()

These headers shouldn't appear inside the body of the patch.
